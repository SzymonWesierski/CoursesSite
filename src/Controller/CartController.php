<?php

namespace App\Controller;

use App\Entity\User;
use App\Repository\CartRepository;
use App\Repository\CourseRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CartController extends AbstractController
{
    private $em;
    private $cartRepository;
    private $courseRepository;

    public function __construct(EntityManagerInterface $em, CourseRepository $courseRepository, 
        CartRepository $cartRepository)
    {
        $this->em = $em;
        $this->courseRepository = $courseRepository;
        $this->cartRepository = $cartRepository;
    }


    #[Route('/cart/add/{courseId}', name: 'add_to_cart')]
    public function addToCart(int $courseId): JsonResponse
    {
        $user = $this->getUser();

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }

        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Course not found');
        }

        $cart = $this->cartRepository->findNotPurchased($user->getId());

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found');
        }

        if ($cart->getAmountOfProducts() == null) {
            $cart->setAmountOfProducts(0);
        }

        $cart->addCourse($course);
        $cart->setAmountOfProducts(count($cart->getCourses()));

        $this->em->persist($cart);
        $this->em->flush();

        return new JsonResponse([
            // 'AmountOfProducts' => $cart->getAmountOfProducts(),
            'productId' => $courseId
        ]);
    }

    #[Route('/cart/counter', name: 'cart_counter')]
    public function cartCounter(): JsonResponse
    {
        $user = $this->getUser();

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }

        $cart = $this->cartRepository->findNotPurchased($user->getId());

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found');
        }

        $amountOfProducts = $cart ? $cart->getAmountOfProducts() : 0;

        return new JsonResponse([
            'AmountOfProducts' => $amountOfProducts,
        ]);
    }
}
