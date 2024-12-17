<?php

namespace App\Controller;

use App\Entity\CourseDraft;
use App\Entity\ChapterDraft;
use App\Form\ChapterDraftFormType;
use App\Repository\ChapterDraftRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class ChapterController extends AbstractController
{

    private $chapterDraftRepository;
    private $em;

    public function __construct(EntityManagerInterface $em, ChapterDraftRepository $chapterDraftRepository)
    {
        $this->em = $em;
        $this->chapterDraftRepository = $chapterDraftRepository;
    }


    #[Route('/chapter/create', name: 'create_chapter')]
    public function create(Request $request): JsonResponse
    {
        $chapter = new ChapterDraft();
        $form = $this->createForm(ChapterDraftFormType::class, $chapter);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $chapter = $form->getData();
            $courseId = $request->request->get('course_id');
            $course = $this->em->getRepository(CourseDraft::class)->find($courseId);
            
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

        $errors = [];
        foreach ($form->get('name')->getErrors() as $error) {
            $errors[] = $error->getMessage();
        }

        return new JsonResponse(['status' => 'error', 'message' => $errors ], 400);

    }

    #[Route('/chapter/edit/{chapterId}', name: 'edit_chapter')]
    public function edit( Request $request, $chapterId = 0): Response
    {
        if($chapterId > 0){
            $chapter = $this->chapterDraftRepository->find($chapterId);
        }else{
            $chapterId = $request->request->get('chapter_id');
            $chapter = $this->chapterDraftRepository->find($chapterId);
        }

        if (!$chapter) {
            throw $this->createNotFoundException('Chapter not found.');
        }

        $form =$this->createForm(ChapterDraftFormType::class, $chapter);

        $form->handleRequest($request);

        if ($request->isXmlHttpRequest()) {
            return $this->render('partials/chapter/_edit.html.twig', [
                'edit_chapter_form' => $form->createView(),
            ]);
        }   

        if($form->isSubmitted() && $form->isValid()){
            
            $this->em->flush();

            return $this->redirectToRoute('edit_course', ['id' => $chapter->getCourseDraft()->getId(), 'section' => 2]);
        }

        return $this->render('partials/chapter/_edit.html.twig', [
            'edit_chapter_form' => $form->createView(),
            'chapter' => $chapter
        ]);
    }

    #[Route('/chapter/delete/{chapterId}', methods: ['GET', 'DELETE'], name: 'delete_chapter')]
    public function delete($chapterId): Response
    {
        $chapter = $this->chapterDraftRepository->find($chapterId);

        if (!$chapter) {
            throw $this->createNotFoundException('Chapter not found.');
        }

        $this->em->remove($chapter);
        $this->em->flush();

        return $this->redirectToRoute('edit_course', ['id' => $chapter->getCourseDraft()->getId(), 'section' => 2]);
    }


}
