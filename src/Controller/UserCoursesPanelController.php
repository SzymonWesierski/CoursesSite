<?php

namespace App\Controller;

use App\Entity\User;
use App\Enum\CourseStatus;
use App\Form\CategoryFilterType;
use App\Repository\CategoryRepository;
use App\Repository\CourseRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Requirement\Requirement;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;


class UserCoursesPanelController extends AbstractController
{
    private $em;
    private $categoryRepository;
    private $courseRepository;

    public function __construct(EntityManagerInterface $em, CourseRepository $courseRepository, CategoryRepository $categoryRepository)
    {
        $this->em = $em;
        $this->categoryRepository = $categoryRepository;
        $this->courseRepository = $courseRepository;
    }


    #[Route('/MyCoursesPanel/{page?}/{categoryId?}', name: 'userCoursesPanel',defaults: ['page' => '1'], requirements: ['page' => Requirement::POSITIVE_INT, 'categoryId' => Requirement::POSITIVE_INT])]
    public function index(Request $request,  $categoryId = null, int $page = 1): Response
    {
        $navBarCategories = $this->categoryRepository->findRootCategories();
        $categoryName = "";
        $user = $this->getUser();

        if (!$user) {
            return $this->redirectToRoute("/login");
        }

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }


        if ($categoryId) {
            $category = $this->categoryRepository->find($categoryId);
            $categoryName = $category->getName();
            
            if ($category) {
                $categories = $this->categoryRepository->findAllChildren($category);
                $categories[] = $category;

                $courses = $this->courseRepository->findUserCoursesByCategoryAndHerChildren($user, $categories ,$page);
            }
        }
        else{
            $courses = $this->courseRepository->findUserAll($user, $page);
        }

        return $this->render('user_courses_panel/index.html.twig', [
            'paginator' => $courses,
            'navBarCategories' => $navBarCategories,
            'categoryName' => $categoryName,
            'categoryId' => $categoryId,
            'statusValues' => [
                'NOT_DONE_YET' => CourseStatus::NOT_DONE_YET->value,
                'WAITING_FOR_APPROVAL' => CourseStatus::WAITING_FOR_APPROVAL->value,
                'APPROVED' => CourseStatus::APPROVED->value,
            ],
        ]);
    }
}
