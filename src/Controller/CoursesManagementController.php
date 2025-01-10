<?php

namespace App\Controller;

use App\Enum\CourseStatus;
use App\Repository\CourseRepository;
use Doctrine\ORM\EntityManagerInterface;
use App\Service\CourseMapperService;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CoursesManagementController extends AbstractController
{
    private $courseRepository;
    private $em;
    private $draftToCourseMapperService;

    public function __construct(CourseRepository $courseRepository, EntityManagerInterface $em,
              CourseMapperService $draftToCourseMapperService) {
        $this->courseRepository = $courseRepository;
        $this->em = $em;
        $this->draftToCourseMapperService = $draftToCourseMapperService;
    }

    #[Route('/courses/management/list/{page?}/{titleParam?}', defaults: ['page' => '1'], name: 'app_courses_management')]
    public function index(Request $request, $page, $titleParam): Response
    {   
        if ($titleParam == null) $titleParam = $request->query->get('titleParam');

        if($titleParam){
            $courses = $this->courseRepository->findAllByTitlePaginated($page, $titleParam);
        }else{
            $courses = $this->courseRepository->findAllPaginated($page);
        }
        
        
        return $this->render('courses_management/index.html.twig', [
            'paginator' => $courses,
            'statusValues' => [
                'DRAFT' => CourseStatus::DRAFT->value,
                'NOT_DONE_YET' => CourseStatus::NOT_DONE_YET->value,
                'WAITING_FOR_APPROVAL' => CourseStatus::WAITING_FOR_APPROVAL->value,
                'APPROVED' => CourseStatus::APPROVED->value,
                'APPROVED_AND_DRAFT' => CourseStatus::APPROVED_AND_DRAFT->value,
                'BANNED' => CourseStatus::BANNED->value,
            ],
            'titleParam' => $titleParam
        ]);
    }

    #[Route('/courses/management/approve/{courseId}', name: 'approve_course')]
    public function approve($courseId): Response
    {
        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $course->setStatus(CourseStatus::APPROVED);

        $courseDraft = $course->getCourseDraft();

        $courseDraft->setStatus(CourseStatus::APPROVED);

        foreach ($course->getChapters() as $chapter) {
            $course->removeChapter($chapter);
        }

        $course = $this->draftToCourseMapperService->mapCourseDraftToCourse($course, $courseDraft);

        $this->em->persist($course);
        $this->em->persist($courseDraft);
        $this->em->flush();

        return $this->redirectToRoute('app_courses_management');
    }

    #[Route('/courses/management/ban/{courseId}', name: 'ban_course')]
    public function ban($courseId): Response
    {
        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $course->setStatus(CourseStatus::BANNED);

        $courseDraft = $course->getCourseDraft();

        $courseDraft->setStatus(CourseStatus::BANNED);

        $this->em->persist($course);

        $this->em->flush();

        return $this->redirectToRoute('app_courses_management');
    }


}
