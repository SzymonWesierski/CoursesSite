<?php

namespace App\Controller;

use App\Entity\User;
use App\Repository\CartRepository;
use App\Repository\CourseRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
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
    public function addToCart(int $courseId): Response
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

        return $this->render('cart/cart_counter_stream.html.twig', [
            'AmountOfProducts' => $cart->getAmountOfProducts(),
            'productId' => $courseId
        ], new Response('', 200, ['Content-Type' => 'text/vnd.turbo-stream.html']));
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

    #[Route('/cart/show', name: 'cart_show')]
    #[Route('/cart', name: 'cart_show')]
    public function index(): Response
    {
        $user = $this->getUser();

        if (!$user instanceof User) {
            throw new \LogicException('Zalogowany użytkownik nie jest instancją encji User.');
        }

        $cart = $this->cartRepository->findNotPurchased($user->getId());

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found');
        }

        $productsInCartIds = $cart->getCourses()->map(fn($course) => $course->getId())->toArray();

        return $this->render('cart/index.html.twig',[
            'cart' => $cart,
            'productsInCartIds' => $productsInCartIds
        ]);
    }

    #[Route('/cart/delete_product/{courseId}/{cartId}', methods: ['GET','DELETE'], name: 'delete_product')]
    public function delete_product($courseId, $cartId): Response
    {
        $cart = $this->cartRepository->find($cartId);

        if (!$cart) {
            throw $this->createNotFoundException('Cart not found.');
        }

        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $cart->removeCourse($course);


        $this->em->persist($cart);
        $this->em->flush();

        return $this->redirectToRoute('cart_show');
    }

}
