<?php

namespace App\Controller;

use App\Entity\Chapter;
use App\Entity\Course;
use App\Entity\User;
use App\Entity\Episode;
use App\Service\CloudinaryService;
use App\Form\EpisodeFormType;
use App\Repository\EpisodeRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\File\Exception\FileException;


class EpisodesController extends AbstractController
{
    private $em;
    private $episodeRepository;
    private $cloudinaryService;

    public function __construct(EntityManagerInterface $em, EpisodeRepository $episodeRepository,
     CloudinaryService $cloudinaryService)
    {
        $this->em = $em;
        $this->episodeRepository = $episodeRepository;
        $this->cloudinaryService = $cloudinaryService;
    }



    #[Route('/episodes', name: 'episodes')]
    public function index(): Response
    {
        $user = $this->getUser();

        if (!$user) {
            return $this->redirectToRoute('/login');
        }

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }

        $episodes = $this->episodeRepository->findAllUserEpisodes($user->getId());
    
        return $this->render('episodes/index.html.twig', [
            'episodes' => $episodes,
        ]);
    }

    #[Route('/episodes/create/{chapter_id}/{course_id}', name: 'create_episode')]
    public function create($chapter_id, $course_id, Request $request): Response
    {
        $episode = new Episode();
        $form = $this->createForm(EpisodeFormType::class, $episode);

        $form->handleRequest($request);

        if($form->isSubmitted() && $form->isValid()){
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
            
            $chapterRepo = $this->em->getRepository(Chapter::class); 
            $chapter = $chapterRepo->find($chapter_id);


            $this->em->persist($newEpisode);
            $chapter->addEpisode($newEpisode);
            
            if (!$chapter) {
                throw $this->createNotFoundException('Chapter not found.');
            }

            $this->em->persist($chapter);
            $this->em->flush();
            
            return $this->redirectToRoute('edit_course', ['id' => $course_id]);
        }

        return $this->render('episodes/create.html.twig', [
            'form' => $form->createView()
        ]);
    }

    #[Route('/episodes/edit/{episodeId}/{courseId}', name: 'edit')]
    public function edit($episodeId, $courseId, Request $request): Response
    {
        $episode = $this->episodeRepository->find($episodeId);

        if (!$episode) {
            throw $this->createNotFoundException('Episode not found.');
        }

        $form = $this->createForm(EpisodeFormType::class, $episode);

        $form->handleRequest($request);

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

            return $this->redirectToRoute('edit_course', ['id' => $courseId]);
        }

        return $this->render('episodes/edit.html.twig', [
            'form' => $form->createView(),
            'episode' => $episode
        ]);
    }

    #[Route('/episodes/delete/{episode_id}/{course_id}', methods: ['GET', 'DELETE'], name: 'delete_episode')]
    public function delete($episode_id, $course_id): Response
    {
        $episode = $this->episodeRepository->find($episode_id);

        if (!$episode) {
            throw $this->createNotFoundException('Episode not found.');
        }

        $currentPublicImageId = $episode->getPublicImageId();
        if($currentPublicImageId){
            $this->cloudinaryService->deleteImage($currentPublicImageId);
        }

        $this->em->remove($episode);
        $this->em->flush();

        return $this->redirectToRoute('edit_course', ['id' => $course_id]);
    }

}
