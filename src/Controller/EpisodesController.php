<?php

namespace App\Controller;

use App\Entity\ChapterDraft;
use App\Entity\EpisodeDraft;
use App\Form\EpisodeDraftFormType;
use App\Service\CloudinaryService;
use Doctrine\ORM\EntityManagerInterface;
use App\Repository\EpisodeDraftRepository;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class EpisodesController extends AbstractController
{
    private $em;
    private $episodeDraftRepository;
    private $cloudinaryService;

    public function __construct(EntityManagerInterface $em, EpisodeDraftRepository $episodeDraftRepository,
     CloudinaryService $cloudinaryService)
    {
        $this->em = $em;
        $this->episodeDraftRepository = $episodeDraftRepository;
        $this->cloudinaryService = $cloudinaryService;
    }

    #[Route('/episodes/create/{chapter_id?}', name: 'create_episode')]
    public function create(Request $request, $chapter_id = 0): Response
    {
        $episode = new EpisodeDraft();
        $form = $this->createForm(EpisodeDraftFormType::class, $episode);

        $form->handleRequest($request);      

        if($form->isSubmitted() && $form->isValid()){

            $chapterRepo = $this->em->getRepository(ChapterDraft::class); 

            if($chapter_id > 0){
                $chapter = $chapterRepo->find($chapter_id);
            }else{
                $chapter_id = $request->request->get('chapter_id');
                $chapter = $chapterRepo->find($chapter_id);
            }
        
            if (!$chapter) {
                throw $this->createNotFoundException('ChapterDraft not found');
            }

            $newEpisode = $form->getData();
            $image = $form->get('image')->getData();
            if ($image) {
                $localImagePath = $image->getRealPath();
                $result = $this->cloudinaryService->uploadImage($localImagePath, $_ENV['CLOUDINARY_IMAGE_EPISODE_FOLDER']);
                $newEpisode->setPublicImageId($result['public_id']);
                $newEpisode->setImagePath($_ENV['CLOUDINARY_IMAGE_URL'] . $result['public_id']);
            }

            $video = $form->get('video')->getData();
            if ($video) {
                $localVideoPath = $video->getRealPath();
                $result = $this->cloudinaryService->uploadVideo($localVideoPath, $_ENV['CLOUDINARY_VIDEO_EPISODE_FOLDER']);
                $newEpisode->setPublicVideoId($result['public_id']);
                $newEpisode->setVideoPath($_ENV['CLOUDINARY_VIDEO_URL'] . $result['public_id']);
            }
            
            $course = $chapter->getCourseDraft();

            $this->em->persist($newEpisode);
            $chapter->addEpisodeDraft($newEpisode);
            
            if (!$chapter) {
                throw $this->createNotFoundException('Chapter not found.');
            }

            $this->em->persist($chapter);
            $this->em->flush();
            
            return $this->redirectToRoute('edit_course', ['id' => $course->getId(), 'section' => 2]);
        }

        return $this->render('partials/episodes/_create.html.twig', [
            'form' => $form->createView()
        ]);
    }

    #[Route('/episodes/edit/{episodeId}/{courseId}', name: 'edit_episode')]
    public function edit( Request $request, $episodeId = 0, $courseId = 0): Response
    {
        if($episodeId > 0){
            $episode = $this->episodeDraftRepository->find($episodeId);
        }else{
            $episodeId = $request->request->get('episode_id');
            $episode = $this->episodeDraftRepository->find($episodeId);
        }

        if (!$episode) {
            throw $this->createNotFoundException('EpisodeDraft not found.');
        }

        if($courseId == 0){
            $courseId = $request->request->get('course_id');
        }

        $form =$this->createForm(EpisodeDraftFormType::class, $episode);

        $form->handleRequest($request);

        if ($request->isXmlHttpRequest()) {
            return $this->render('partials/episodes/_edit.html.twig', [
                'edit_episode_form' => $form->createView(),
            ]);
        }   


        if($form->isSubmitted() && $form->isValid()){
            
            $image = $form->get('image')->getData();
            if ($image) {
                $localImagePath = $image->getRealPath();
                $result = $this->cloudinaryService->uploadImage($localImagePath, $_ENV['CLOUDINARY_IMAGE_EPISODE_FOLDER']);
                $episode->setPublicImageId($result['public_id']);
                $episode->setImagePath($_ENV['CLOUDINARY_IMAGE_URL'] . $result['public_id']);
            }
            
            $video = $form->get('video')->getData();
            if ($video) {
                $localVideoPath = $video->getRealPath();
                $result = $this->cloudinaryService->uploadVideo($localVideoPath, $_ENV['CLOUDINARY_VIDEO_EPISODE_FOLDER']);
                $episode->setPublicVideoId($result['public_id']);
                $episode->setVideoPath($_ENV['CLOUDINARY_VIDEO_URL'] . $result['public_id']);
            }

            $this->em->flush();

            return $this->redirectToRoute('edit_course', ['id' => $courseId, 'section' => 2]);
        }

        return $this->render('partials/episodes/_edit.html.twig', [
            'edit_episode_form' => $form->createView(),
            'episode' => $episode
        ]);
    }

    #[Route('/episodes/delete/{episode_id}/{course_id}', methods: ['GET', 'DELETE'], name: 'delete_episode')]
    public function delete($episode_id, $course_id): Response
    {
        $episode = $this->episodeDraftRepository->find($episode_id);

        if (!$episode) {
            throw $this->createNotFoundException('EpisodeDraft not found.');
        }

        $currentPublicImageId = $episode->getPublicImageId();
        if($currentPublicImageId){
            $this->cloudinaryService->deleteImage($currentPublicImageId);
        }

        $this->em->remove($episode);
        $this->em->flush();

        return $this->redirectToRoute('edit_course', ['id' => $course_id, 'section' => 2]);
    }

}
