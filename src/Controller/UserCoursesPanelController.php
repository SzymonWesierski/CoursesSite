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


    #[Route('/MyCoursesPanel/{categoryId}', name: 'userCoursesPanel', requirements: ['categoryId' => '\d+'])]
    public function index(Request $request, EntityManagerInterface $em, $categoryId = null): Response
    {
        $form = $this->createForm(CategoryFilterType::class);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid())
        {
            $categoryId = $form->get('category')->getData();
            return $this->redirectToRoute('userCoursesPanel', ['categoryId' => $categoryId ]);
        }

        $user = $this->getUser();

        if (!$user) {
            return $this->redirectToRoute("/login");
        }

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }


        if ($categoryId) {
            $category = $this->categoryRepository->find($categoryId);

            if ($category) {
                $categories = $this->categoryRepository->findAllChildren($category);
                $categories[] = $category;

                $courses = $this->courseRepository->findUserCoursesByCategoryAndHerChildren($categories, $user);
            }
        }
        else{
            $courses = $this->courseRepository->findUserAll($user);
        }

        return $this->render('user_courses_panel/index.html.twig', [
            'courses' => $courses,
            'form' => $form->createView(),
            'statusValues' => [
                'NOT_DONE_YET' => CourseStatus::NOT_DONE_YET->value,
                'WAITING_FOR_APPROVAL' => CourseStatus::WAITING_FOR_APPROVAL->value,
                'APPROVED' => CourseStatus::APPROVED->value,
            ],
        ]);
    }
}
