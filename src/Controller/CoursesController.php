<?php
// src/Controller/CoursesController.php
namespace App\Controller;

use App\Entity\Cart;
use App\Entity\User;
use App\Entity\Course;
use App\Entity\Episode;
use App\Enum\CourseStatus;
use App\Entity\CourseDraft;
use App\Entity\ChapterDraft;
use App\Entity\EpisodeDraft;
use App\Form\CourseFormType;
use App\Form\CourseDraftFormType;
use App\Form\ChapterDraftFormType;
use App\Form\EpisodeDraftFormType;
use App\Service\CloudinaryService;
use App\Repository\CourseRepository;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;
use App\Repository\CourseDraftRepository;
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
    private $courseDraftRepository;
    private $cloudinaryService;

    public function __construct(EntityManagerInterface $em, CourseRepository $courseRepository, 
        CourseDraftRepository $courseDraftRepository, CategoryRepository $categoryRepository,
        CloudinaryService $cloudinaryService)
    {
        $this->em = $em;
        $this->courseRepository = $courseRepository;
        $this->courseDraftRepository = $courseDraftRepository;
        $this->categoryRepository = $categoryRepository;
        $this->cloudinaryService = $cloudinaryService;
    }

    #[Route('/', name: 'app_home_redirect')]
    public function redirectToHomepage(): Response
    {
        return $this->redirectToRoute('courses');
    }

    #[Route('/courses/{page?}/{categoryId?}/{titleParam?}', name: 'courses', defaults: ['page' => '1', 'categoryId' => '0'], requirements: ['page' => Requirement::POSITIVE_INT])]
    public function index(Request $request, $categoryId, $titleParam, $page): Response
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
        
        if ($titleParam == null) $titleParam = $request->query->get('titleParam');
        
        if ($categoryId > 0) {
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
        else if($titleParam){
            $courses = $this->courseRepository->findAllByTitlePaginated($page, $titleParam);
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
            'purchasedCoursesIds' => $purchasedCoursesIds,
            'titleParam' => $titleParam
        ]);
    }


    #[Route('/courses/show/{courseId}/{episodeId}', methods: ['GET'], name: 'show_course')]
    public function show(string $courseId, int $episodeId = 0): Response
    {
        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Episode not found.');
        }

        $productsInCartIds = [];
        $amountOfProducts = 0;
        $isPurchased = false;

        $user = $this->getUser();

        if ($user instanceof User) {
            $cart = $this->em->getRepository(Cart::class)->findNotPurchased($user->getId());

            if (!$cart) {
                throw $this->createNotFoundException('Cart not found');
            }
            $amountOfProducts = $cart->getAmountOfProducts(); 
            $productsInCartIds = $cart->getCourses()->map(fn($course) => $course->getId())->toArray();
            
            if($this->courseRepository->isPurchasedCourse($courseId, $user->getId())) {
                $isPurchased = true;
            }
            // if ($user->getId() == $course->getUser()->getId()){
            //     $isPurchased = true;
            // }
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
            'isPurchased' => $isPurchased,
            'productsInCartIds' => $productsInCartIds,
            'amountOfProducts' => $amountOfProducts
        ]);
    }

    #[Route('/courses/preview/{courseId}/{episodeId}', methods: ['GET'], name: 'preview_course')]
    public function preview(string $courseId, int $episodeId = 0): Response
    {
        $course = $this->courseDraftRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('CourseDraft not found.');
        }

        $user = $this->getUser();

        $episode = new EpisodeDraft();

        if ($episodeId > 0){
            $episodeRepo = $this->em->getRepository(EpisodeDraft::class);

            if (!$episodeId || !is_numeric($episodeId)) {
                throw $this->createNotFoundException('Episode ID is missing or invalid.');
            }

            $episode = $episodeRepo->find($episodeId);

            if (!$episode) {
                throw $this->createNotFoundException('Episode not found.');
            }
        }
        

        return $this->render('courses/preview.html.twig', [
            'course' => $course,
            'episode' => $episode,
            'episodeId' => $episodeId,
            'username' => $user->getUserIdentifier()
        ]);
    }

    #[Route('/courses/delete/{id}', methods: ['GET','DELETE'], name: 'delete_course')]
    public function delete($id): Response
    {
        $course = $this->courseRepository->find($id);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $user = $this->getUser();

        if ($user instanceof User) {
            if ($course->getUser()->getId() !=  $user->getId()){
                throw $this->createAccessDeniedException();
            }
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

            $courseDraft = new CourseDraft();
            $courseDraft->setName($newCourse->getName());
            $courseDraft->setDescription($newCourse->getDescription());
            $courseDraft->setStatus($newCourse->getStatus());
            $courseDraft->setCourse($newCourse);
            $courseDraft->setCategory($newCourse->getCategory());

            $this->em->persist($courseDraft);

            $this->em->flush();

            return $this->redirectToRoute('userCoursesPanel');
        }

        return $this->render('courses/create.html.twig', [
            'form' => $form->createView()
        ], new Response(null, $form->isSubmitted() && !$form->isValid() ? 422 : 200));;
    }

    #[Route('/courses/edit/{id}/{section?}', name: 'edit_course')]
    public function edit($id, Request $request, $section = 0): Response 
    {
        $courseDraft = $this->courseDraftRepository->find($id);

        if (!$courseDraft) {
            throw $this->createNotFoundException('Course draft not found.');
        }

        $user = $this->getUser();

        if ($user instanceof User) {
            if ($courseDraft->getCourse()->getUser()->getId() !=  $user->getId()){
                throw $this->createAccessDeniedException();
            }
        }

        $course_form = $this->createForm(CourseDraftFormType::class, $courseDraft);

        $chapter = new ChapterDraft();
        $chapter_form = $this->createForm(ChapterDraftFormType::class, $chapter);

        $episode = new EpisodeDraft();
        $episode_form = $this->createForm(EpisodeDraftFormType::class, $episode);


        $course_form->handleRequest($request);

        if ($course_form->isSubmitted() && $course_form->isValid()) {

            $image = $course_form->get('image')->getData();
            if ($image) {
                $currentPublicImageId = $courseDraft->getPublicImageId();
                if($currentPublicImageId){
                    $this->cloudinaryService->deleteImage($currentPublicImageId);
                }
                $localImagePath = $image->getRealPath();
                $result = $this->cloudinaryService->uploadImage($localImagePath, "CourseSite/Course");
                $courseDraft->setPublicImageId($result['public_id']);
                $courseDraft->setImagePath($_ENV['CLOUDINARY_IMAGE_URL'] . $result['public_id']);  
            } 

            $courseDraft->setStatus(CourseStatus::DRAFT);

            $this->em->flush();
            return $this->redirectToRoute('userCoursesPanel');
        }

        return $this->render('courses/edit.html.twig', [
            'course_form' => $course_form->createView(),
            'create_chapter_form' => $chapter_form->createView(),
            'edit_chapter_form' =>  $chapter_form->createView(),
            'create_episode_form' => $episode_form->createView(),
            'edit_episode_form' => $episode_form->createView(),
            'course' => $courseDraft,
            'initialSectionIndex' => $section
        ], new Response(null, $course_form->isSubmitted() && !$course_form->isValid() ? 422 : 200));
    }
}

