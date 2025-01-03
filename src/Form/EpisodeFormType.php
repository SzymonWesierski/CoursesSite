<?php

namespace App\Form;

use App\Entity\Episode;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;

class EpisodeFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('name', TextType::class, [
                'required' => true,
                'label' => 'Title:',
                'constraints' => [
                    new NotBlank([
                        'message' => 'Please enter the title',
                    ])
                ],
            ])
            ->add('description', TextareaType::class,[
                'required' => true,
                'label' => 'Description:',
                'constraints' => [
                    new NotBlank([
                        'message' => 'Please enter the description',
                    ])
                ],
            ])
            ->add('video', FileType::class, [
                'required' => false,
                'mapped' => false,
                'label' => "Video (max 50MB): ",
                'constraints' => [
                    new File([
                        'maxSize' => '50M',
                        'mimeTypes' => [
                            'video/mp4',
                            'video/avi',
                            'video/mpeg',
                            'video/quicktime',
                        ],
                        'mimeTypesMessage' => 'Video is too large or has a wrong extension.',
                    ])
                ],
            ])
            ->add('image', FileType::class, [
                'required' => false,
                'mapped' => false,
                'label' => "Image (max 10MB):",
                'constraints' => [
                    new File([
                        'maxSize' => '10M',
                        'mimeTypes' => [
                            'image/jpeg',
                            'image/png',
                            'image/gif',
                            'image/webp',
                        ],
                        'mimeTypesMessage' => 'Image is too large or has a wrong extension.',
                    ])
                ],
            ])
            ->add('isFreeToWatch', CheckboxType::class, array(
                'required' => false,
                'label' => "Is free to watch? :",
            ))
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Episode::class,
        ]);
    }
}
