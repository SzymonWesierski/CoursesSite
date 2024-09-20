<?php

namespace App\Controller;

use App\Entity\User;
use App\Entity\Episode;
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

    public function __construct(EntityManagerInterface $em, EpisodeRepository $episodeRepository)
    {
        $this->em = $em;
        $this->episodeRepository = $episodeRepository;
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

    #[Route('/episodes/create', name: 'create_episode')]
    public function create(Request $request): Response
    {
        $episode = new Episode();
        $form = $this->createForm(EpisodeFormType::class, $episode);

        $form->handleRequest($request);

        if($form->isSubmitted() && $form->isValid()){
            $newEpisode = $form->getData();
            $imagePath = $form->get('imagePath')->getData(); 
            
            if ($imagePath) {
                $newFileName = uniqid() . '.' . $imagePath->guessExtension();

                try {
                    $imagePath->move(
                        $this->getParameter('kernel.project_dir') . '/public/uploads',
                        $newFileName
                    );
                } catch (FileException $e) {
                    return new Response($e->getMessage());
                }
                $newEpisode->setImagePath('/uploads/' . $newFileName);
            }
            
            $this->em->persist($newEpisode);
            $this->em->flush();

            return $this->redirectToRoute('episodes');
        }

        return $this->render('episodes/create.html.twig', [
            'form' => $form->createView()
        ]);
    }



}
