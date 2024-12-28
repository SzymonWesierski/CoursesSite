<?php

namespace App\Controller;

use App\Entity\Cart;
use App\Entity\User;
use App\Enum\CourseStatus;
use App\Form\CategoryFilterType;
use App\Repository\CourseRepository;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;
use App\Repository\CourseDraftRepository;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Routing\Requirement\Requirement;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;


class UserCoursesPanelController extends AbstractController
{
    private $em;
    private $categoryRepository;
    private $courseRepository;
    private $courseDraftRepository;

    public function __construct(EntityManagerInterface $em, CourseRepository $courseRepository,  CourseDraftRepository $courseDraftRepository, CategoryRepository $categoryRepository)
    {
        $this->em = $em;
        $this->categoryRepository = $categoryRepository;
        $this->courseRepository = $courseRepository;
        $this->courseDraftRepository = $courseDraftRepository;
    }


    #[Route('/MyCoursesPanel/{page?}/{categoryId?}/{titleParam?}', name: 'userCoursesPanel',defaults: ['page' => '1'], requirements: ['page' => Requirement::POSITIVE_INT, 'categoryId' => Requirement::POSITIVE_INT])]
    public function index(Request $request,  $categoryId = null, int $page = 1, $titleParam): Response
    {
        $navBarCategories = $this->categoryRepository->findRootCategories();
        $categoryName = "";
        $user = $this->getUser();
        $amountOfProducts = 0;

        if (!$user) {
            return $this->redirectToRoute("/login");
        }

        if (!$user instanceof User) {
            throw new \LogicException('Logged in user is not instance of User.');
        }

        $cart = $this->em->getRepository(Cart::class)->findNotPurchased($user->getId());

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found');
        }

        $amountOfProducts = $cart->getAmountOfProducts(); 

        if ($titleParam == null) $titleParam = $request->query->get('titleParam');

        if ($categoryId) {
            $category = $this->categoryRepository->find($categoryId);
            $categoryName = $category->getName();
            
            if ($category) {
                $categories = $this->categoryRepository->findAllChildren($category);
                $categories[] = $category;

                $courses = $this->courseDraftRepository->findUserDraftCoursesByCategoryAndHerChildren($categories, $user, $page);
            }
        }
        else if($titleParam){
            $courses = $this->courseDraftRepository->findAllDraftsByTitlePaginated($page, $user, $titleParam);
        }
        else{
            $courses = $this->courseDraftRepository->findUserAllDraftCourses($user, $page);
        }

        return $this->render('user_courses_panel/instructor.html.twig', [
            'paginator' => $courses,
            'navBarCategories' => $navBarCategories,
            'categoryName' => $categoryName,
            'categoryId' => $categoryId,
            'amountOfProducts' => $amountOfProducts,
            'statusValues' => [
                'NOT_DONE_YET' => CourseStatus::NOT_DONE_YET->value,
                'WAITING_FOR_APPROVAL' => CourseStatus::WAITING_FOR_APPROVAL->value,
                'APPROVED' => CourseStatus::APPROVED->value,
                'DRAFT' => CourseStatus::DRAFT->value,
                'BANNED' => CourseStatus::BANNED->value,
                'APPROVED_AND_DRAFT' => CourseStatus::APPROVED_AND_DRAFT->value,
            ],
            'titleParam' => $titleParam
        ]);
    }

    #[Route('/myLearning', name: 'myLearning')]
    public function myLearning(): Response
    {
        $amountOfProducts = 0;
        $courses = array();
        $user = $this->getUser();
        $courses = [];

        if (!$user) {
            return $this->redirectToRoute("/login");
        }

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }

        $courses = $this->courseRepository->findPurchasedCourses($user->getId());

        return $this->render('user_courses_panel/myLearning.html.twig', [
            'courses' => $courses,
            'amountOfProducts' => $amountOfProducts
        ]);
    }
}
