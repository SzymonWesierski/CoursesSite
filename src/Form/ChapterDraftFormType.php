<?php

namespace App\Form;

use App\Entity\ChapterDraft;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Validator\Constraints as Assert;

class ChapterDraftFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {   

        $builder
            ->add('name', TextType::class, [
                'attr' => [
                    'placeholder' => 'Enter title...',
                ],
                'label' => false,
                'required' => true,
                'constraints' => [
                    new Assert\NotBlank([
                        'message' => 'The title is required.',
                    ]),
                    new Assert\Length([
                        'max' => 255,
                        'maxMessage' => 'The title cannot exceed {{ limit }} characters.',
                    ]),
                ],
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => ChapterDraft::class,
        ]);
    }
}
