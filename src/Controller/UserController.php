<?php

namespace App\Controller;

use App\Entity\Cart;
use App\Entity\User;
use App\Entity\Category;
use App\Form\UserEditFormType;
use App\Service\CloudinaryService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class UserController extends AbstractController
{
    private $em;
    private $cloudinaryService;

    public function __construct(EntityManagerInterface $em, CloudinaryService $cloudinaryService)
    {
        $this->em = $em;
        $this->cloudinaryService = $cloudinaryService;
    }

    #[Route('/editProfile', name: 'app_user_edit')]
    public function index(): Response
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

        return $this->render('user/edit.html.twig', [
            'navBarCategories' => $navBarCategories,
            'amountOfProducts' => $amountOfProducts,
            'user' => $user
        ]);
    }
}
