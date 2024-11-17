<?php

namespace App\Controller;

use App\Entity\Cart;
use App\Entity\User;
use App\Entity\Category;
use App\Form\UserEditFormType;
use App\Repository\UserRepository;
use App\Service\CloudinaryService;
use App\Form\AdminUserEditFormType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Routing\Requirement\Requirement;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class UserController extends AbstractController
{
    private $em;
    private $cloudinaryService;
    private $userRepository;

    public function __construct(EntityManagerInterface $em, CloudinaryService $cloudinaryService,
        UserRepository $userRepository)
    {
        $this->em = $em;
        $this->cloudinaryService = $cloudinaryService;
        $this->userRepository = $userRepository;
    }

    #[Route('/editProfile', name: 'app_user_edit')]
    public function editProfile(): Response
    {
        $user = $this->getUser();
        $navBarCategories = $this->em->getRepository(Category::class)->findRootCategories();
        $amountOfProducts = 0;

        if (!$user) {
            return $this->redirectToRoute("/login");
        }

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }

        $cart = $this->em->getRepository(Cart::class)->findNotPurchased($user->getId());

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found');
        }

        $amountOfProducts = $cart->getAmountOfProducts(); 

        return $this->render('user/edit_profile.html.twig', [
            'navBarCategories' => $navBarCategories,
            'amountOfProducts' => $amountOfProducts,
            'user' => $user
        ]);
    }

    #[Route('/users/{page}', name: 'users', defaults: ['page' => 1], requirements: ['page' => Requirement::POSITIVE_INT])]
    public function index(Request $request, int $page = 1): Response
    {
        $usernameParam = $request->query->get('usernameParam');

        if ($usernameParam) {
            $users = $this->userRepository->findAllByUsernamePaginated($page, $usernameParam);
        } else {
            $users = $this->userRepository->findAllPaginated($page);
        }
        
        return $this->render('user/index.html.twig', [
            'paginator' => $users,
            'usernameParam' => $usernameParam
        ]);
    }


    #[Route('/users/edit/{userId}', name: 'edit_user')]
    public function edit($userId, Request $request): Response
    {
        $user = $this->userRepository->find($userId);

        if (!$user) {
            throw $this->createNotFoundException('User not found.');
        }

        $user_form = $this->createForm(AdminUserEditFormType::class, $user);

        $user_form->handleRequest($request);

         if ($user_form->isSubmitted() && $user_form->isValid()) {
            $this->em->flush();
            return $this->redirectToRoute('users');
         }

        return $this->render('user/edit.html.twig', [
            'user_form' => $user_form
        ]);
    }

    #[Route('/users/delete/{userId}', name: 'delete_user')]
    public function delete($userId): Response
    {
        $user = $this->userRepository->find($userId);

        if (!$user) {
            throw $this->createNotFoundException('User not found.');
        }

        $this->em->remove($user);

        $this->em->flush();

        return $this->redirectToRoute('users');
    }

}
