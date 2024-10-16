<?php
// src/Controller/CoursesController.php
namespace App\Controller;

use App\Entity\Course;
use App\Entity\Cart;
use App\Entity\Chapter;
use App\Entity\Episode;
use App\Entity\User;
use App\Enum\CourseStatus;
use App\Form\CourseFormType;
use App\Form\ChapterFormType;
use App\Service\CloudinaryService;
use App\Repository\CourseRepository;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Mapping\Id;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Routing\Requirement\Requirement;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CoursesController extends AbstractController
{
    private $em;
    private $courseRepository;
    private $categoryRepository;
    private $cloudinaryService;

    public function __construct(EntityManagerInterface $em, CourseRepository $courseRepository, 
        CategoryRepository $categoryRepository, CloudinaryService $cloudinaryService)
    {
        $this->em = $em;
        $this->courseRepository = $courseRepository;
        $this->categoryRepository = $categoryRepository;
        $this->cloudinaryService = $cloudinaryService;
    }

    #[Route('/', name: 'app_home_redirect')]
    public function redirectToHomepage(): Response
    {
        return $this->redirectToRoute('courses');
    }

    #[Route('/courses/{page?}/{categoryId?}', name: 'courses', defaults: ['page' => '1'], requirements: ['page' => Requirement::POSITIVE_INT, 'categoryId' => Requirement::POSITIVE_INT])]
    public function index($categoryId = null, int $page = 1): Response
    {   
        $user = $this->getUser();
        $navBarCategories = $this->categoryRepository->findRootCategories();
        $categoryName = "";
        $productsInCartIds = [];
        $coursesTheBestByRating = [];
        $purchasedCoursesIds = [];
        $amountOfProducts = 0;
        $cart = new Cart();

        if ($user instanceof User) {
            $cart = $this->em->getRepository(Cart::class)->findNotPurchased($user->getId());
            $purchasedCoursesIds = $this->courseRepository->findPurchasedCoursesIds($user->getId());
        }

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found');
        }

        $amountOfProducts = $cart->getAmountOfProducts(); 
        $productsInCartIds = $cart->getCourses()->map(fn($course) => $course->getId())->toArray();
        

        if ($categoryId) {
            $category = $this->categoryRepository->find($categoryId);

            if (!$category) {
                throw $this->createNotFoundException('Course not found');
            }

            $categoryName = $category->getName();

            if ($category) {
                $categories = $this->categoryRepository->findAllChildren($category);
                $categories[] = $category;

                $courses = $this->courseRepository->findAllAprovedByCategoryAndHerChildren( $categories, $page);
            }
        }
        else{
            $courses = $this->courseRepository->findAllApproved($page);
            $coursesTheBestByRating = $this->courseRepository->findWithTheBestRating();
        }

        return $this->render('courses/index.html.twig', [
            'paginator' => $courses,
            'categoryId' => $categoryId,
            'categoryName' => $categoryName,
            'navBarCategories' => $navBarCategories,
            'productsInCartIds' => $productsInCartIds,
            'coursesTheBestByRating' => $coursesTheBestByRating,
            'amountOfProducts' => $amountOfProducts,
            'purchasedCoursesIds' => $purchasedCoursesIds
        ]);
    }


    #[Route('/courses/show/{courseId}/{episodeId}', methods: ['GET'], name: 'show_course')]
    public function show(int $courseId, int $episodeId = 0): Response
    {
        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Episode not found.');
        }

        $productsInCartIds = [];
        $amountOfProducts = 0;

        $user = $this->getUser();

        if ($user instanceof User) {
            $cart = $this->em->getRepository(Cart::class)->findNotPurchased($user->getId());

            if (!$cart) {
                throw $this->createNotFoundException('Cart not found');
            }
            $amountOfProducts = $cart->getAmountOfProducts(); 
            $productsInCartIds = $cart->getCourses()->map(fn($course) => $course->getId())->toArray();
        }

        $episode = new Episode();

        if ($episodeId > 0){
            $episodeRepo = $this->em->getRepository(Episode::class);

            if (!$episodeId || !is_numeric($episodeId)) {
                throw $this->createNotFoundException('Episode ID is missing or invalid.');
            }

            $episode = $episodeRepo->find($episodeId);

            if (!$episode) {
                throw $this->createNotFoundException('Episode not found.');
            }
        }
        

        return $this->render('courses/show.html.twig', [
            'course' => $course,
            'episode' => $episode,
            'episodeId' => $episodeId,
            'productsInCartIds' => $productsInCartIds,
            'amountOfProducts' => $amountOfProducts
        ]);
    }

    #[Route('/courses/delete/{id}', methods: ['GET','DELETE'], name: 'delete_course')]
    public function delete($id): Response
    {
        $course = $this->courseRepository->find($id);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $currentPublicImageId = $course->getPublicImageId();
        if($currentPublicImageId){
            $this->cloudinaryService->deleteImage($currentPublicImageId);
        }
        $this->em->remove($course);
        $this->em->flush();

        return $this->redirectToRoute('userCoursesPanel');
    }

    #[Route('/courses/create', name: 'create_course')]
    public function create(Request $request): Response
    {
        $course = new Course();
        $form = $this->createForm(CourseFormType::class, $course);

        $form->handleRequest($request);

        if($form->isSubmitted() && $form->isValid()){
            $newCourse = $form->getData();
            $newCourse->setUser($this->getUser());
            $newCourse->setRatingAverage(0.0);
            $newCourse->setStatus(CourseStatus::NOT_DONE_YET);
            $image = $form->get('image')->getData();
            if ($image) {
                $localImagePath = $image->getRealPath();
                $result = $this->cloudinaryService->uploadImage($localImagePath, "CourseSite/Course");
                $newCourse->setPublicImageId($result['public_id']);
                $newCourse->setImagePath($_ENV['CLOUDINARY_IMAGE_URL'] . $result['public_id']);
            }
            
            $this->em->persist($newCourse);
            $this->em->flush();

            return $this->redirectToRoute('userCoursesPanel');
        }

        return $this->render('courses/create.html.twig', [
            'form' => $form->createView()
        ]);
    }

    #[Route('/courses/edit/{id}', name: 'edit_course')]
    public function edit($id, Request $request): Response 
    {
        $course = $this->courseRepository->find($id);

        if (!$course) {
            throw $this->createNotFoundException('Episode not found.');
        }

        $course_form = $this->createForm(CourseFormType::class, $course);

        $chapter = new Chapter();
        $chapter_form = $this->createForm(ChapterFormType::class, $chapter);

        $course_form->handleRequest($request);

        if ($course_form->isSubmitted() && $course_form->isValid()) {

            $image = $course_form->get('image')->getData();
            if ($image) {
                $currentPublicImageId = $course->getPublicImageId();
                if($currentPublicImageId){
                    $this->cloudinaryService->deleteImage($currentPublicImageId);
                }
                $localImagePath = $image->getRealPath();
                $result = $this->cloudinaryService->uploadImage($localImagePath, "CourseSite/Course");
                $course->setPublicImageId($result['public_id']);
                $course->setImagePath($_ENV['CLOUDINARY_IMAGE_URL'] . $result['public_id']);
                
            } 

            $this->em->flush();
            return $this->redirectToRoute('userCoursesPanel');
        }

        return $this->render('courses/edit.html.twig', [
            'course_form' => $course_form->createView(),
            'chapter_form' => $chapter_form->createView(),
            'course' => $course
        ]);
    }
}

