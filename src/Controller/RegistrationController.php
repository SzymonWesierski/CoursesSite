<?php

namespace App\Controller;

use App\Entity\Cart;
use App\Entity\User;
use App\Security\EmailVerifier;
use App\Form\RegistrationFormType;
use App\Repository\UserRepository;
use Symfony\Component\Mime\Address;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Contracts\Translation\TranslatorInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use SymfonyCasts\Bundle\VerifyEmail\Exception\VerifyEmailExceptionInterface;

class RegistrationController extends AbstractController
{
    public function __construct(private EmailVerifier $emailVerifier)
    {
    }

    #[Route('/register', name: 'app_register')]
    public function register(Request $request, UserPasswordHasherInterface $userPasswordHasher, 
    EntityManagerInterface $entityManager,MailerInterface $mailer): Response
    {
        $user = new User();
        $form = $this->createForm(RegistrationFormType::class, $user);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            /** @var string $plainPassword */
            $plainPassword = $form->get('plainPassword')->getData();

            // encode the plain password
            $user->setPassword($userPasswordHasher->hashPassword($user, $plainPassword));
            $user->setRoles(['ROLE_USER']);

            $cart = new Cart();
            $cart->setAmountOfProducts(0);
            $cart->setPurchased(false);
            $cart->setTotalValue(0);
            $cart->setUser($user);

            $entityManager->persist($user);
            $entityManager->persist($cart);

            $entityManager->flush();

            $this->emailVerifier->sendEmailConfirmation('app_verified_email', $user,
                (new TemplatedEmail())
                    ->from(new Address('mailgun@CourseSite.com'))
                    ->to((string) $user->getEmail())
                    ->subject('Please Confirm your Email')
                    ->htmlTemplate('registration/confirmation_email.html.twig')
            );

            return $this->redirectToRoute('app_verify_email', ["userId" => $user->getId()]);
        }

        return $this->render('registration/register.html.twig', [
            'registrationForm' => $form,
        ]);
    }

    #[Route('/email/verified ', name: 'app_verified_email')]
    public function verifiedUserEmail(Request $request, TranslatorInterface $translator, UserRepository $userRepository): Response
    {
        $id = $request->query->get('id');

        if (null === $id) {
            return $this->redirectToRoute('app_register');
        }

        $user = $userRepository->find($id);

        if (null === $user) {
            return $this->redirectToRoute('app_register');
        }

        // validate email confirmation link, sets User::isVerified=true and persists
        try {
            $this->emailVerifier->handleEmailConfirmation($request, $user);
        } catch (VerifyEmailExceptionInterface $exception) {
            $this->addFlash('verify_email_error', $translator->trans($exception->getReason(), [], 'VerifyEmailBundle'));

            return $this->redirectToRoute('app_register');
        }

        // @TODO Change the redirect on success and handle or remove the flash message in your templates
        $this->addFlash('success', 'Your email address has been verified.');
        
        return $this->render('registration/verified_successfully.html.twig', [
        ]);
    }

    #[Route('/email/verify/{userId}', name: 'app_verify_email')]
    public function verifyUserEmail(string $userId): Response
    {
        return $this->render('registration/verification_info.html.twig', [
            'userId' => $userId
        ]);
    }

    #[Route('/email/resend', name: 'app_resend_email_ajax', methods: ['POST'])]
    public function resendEmailAjax(Request $request, UserRepository $userRepository): JsonResponse
    {
        $id = $request->request->get('id');

        if (null === $id) {
            return new JsonResponse(['status' => 'error', 'message' => 'User ID is missing.'], Response::HTTP_BAD_REQUEST);
        }

        $user = $userRepository->find($id);

        if (null === $user) {
            return new JsonResponse(['status' => 'error', 'message' => 'User not found.'], Response::HTTP_NOT_FOUND);
        }

        if ($user->getIsVerified()) {
            return new JsonResponse(['status' => 'info', 'message' => 'This email is already verified.'], Response::HTTP_OK);
        }

        $this->emailVerifier->sendEmailConfirmation('app_verified_email', $user,
            (new TemplatedEmail())
                ->from(new Address('mailgun@CourseSite.com'))
                ->to((string) $user->getEmail())
                ->subject('Please Confirm your Email')
                ->htmlTemplate('registration/confirmation_email.html.twig')
        );

        return new JsonResponse(['status' => 'success', 'message' => 'Verification email resent successfully.'], Response::HTTP_OK);
    }


}
