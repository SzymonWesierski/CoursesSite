<?php

namespace App\Controller;

use App\Entity\Course;
use App\Entity\Chapter;
use App\Form\ChapterFormType;
use App\Repository\ChapterRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class ChapterController extends AbstractController
{

    private $chapterRepository;
    private $em;

    public function __construct(EntityManagerInterface $em, ChapterRepository $chapterRepository)
    {
        $this->em = $em;
        $this->chapterRepository = $chapterRepository;
    }


    #[Route('/chapter/create', name: 'create_chapter')]
    public function create(Request $request): JsonResponse
    {
        $chapter = new Chapter();
        $form = $this->createForm(ChapterFormType::class, $chapter);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $chapter = $form->getData();

            $courseId = $request->request->get('course_id');
            $course = $this->em->getRepository(Course::class)->find($courseId);
            
            if ($course) {
                $this->em->persist($chapter);
                $course->addChapter($chapter);
                $this->em->persist($course);
                $this->em->flush();

                return new JsonResponse([
                    'status' => 'success',
                    'chapter' => [
                        'id' => $chapter->getId(),
                        'name' => $chapter->getName(),
                    ],
                    'courseId' => $courseId
                ]);
            }
        }

        return new JsonResponse(['status' => 'error', 'message' => 'Form is not valid.'], 400);

    }

    #[Route('/chapter/edit/{chapterId}', name: 'edit_chapter')]
    public function edit( Request $request, $chapterId = 0): Response
    {
        if($chapterId > 0){
            $chapter = $this->chapterRepository->find($chapterId);
        }else{
            $chapterId = $request->request->get('chapter_id');
            $chapter = $this->chapterRepository->find($chapterId);
        }

        if (!$chapter) {
            throw $this->createNotFoundException('Chapter not found.');
        }

        $form =$this->createForm(ChapterFormType::class, $chapter);

        $form->handleRequest($request);

        if ($request->isXmlHttpRequest()) {
            return $this->render('partials/chapter/_edit.html.twig', [
                'edit_chapter_form' => $form->createView(),
            ]);
        }   

        if($form->isSubmitted() && $form->isValid()){
            
            $this->em->flush();

            return $this->redirectToRoute('edit_course', ['id' => $chapter->getCourse()->getId(), 'section' => 2]);
        }

        return $this->render('partials/chapter/_edit.html.twig', [
            'edit_chapter_form' => $form->createView(),
            'chapter' => $chapter
        ]);
    }

    #[Route('/chapter/delete/{chapterId}', methods: ['GET', 'DELETE'], name: 'delete_chapter')]
    public function delete($chapterId): Response
    {
        $chapter = $this->chapterRepository->find($chapterId);

        if (!$chapter) {
            throw $this->createNotFoundException('Chapter not found.');
        }

        $this->em->remove($chapter);
        $this->em->flush();

        return $this->redirectToRoute('edit_course', ['id' => $chapter->getCourse()->getId(), 'section' => 2]);
    }


}
