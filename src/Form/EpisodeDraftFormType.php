<?php

namespace App\Form;

use App\Entity\EpisodeDraft;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;

class EpisodeDraftFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('episode_id', HiddenType::class, [
                'mapped' => false,
            ])
            ->add('chapter_id', HiddenType::class, [
                'mapped' => false,
            ])
            ->add('name', TextType::class, [
                'required' => false,
                'empty_data' => '',
                'label' => 'Title:',
            ])
            ->add('description', TextareaType::class,[
                'required' => false,
                'empty_data' => '',
                'label' => 'Description:',
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
            'data_class' => EpisodeDraft::class,
        ]);
    }
}
