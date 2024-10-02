<?php

namespace App\Form;

use App\Entity\Category;
use App\Entity\Course;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;

class CourseFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('name', TextType::class, [
                'attr' => array(
                    'class' => 'bg-transparent block border-b-2 w-full h-20 text-6xl outline-none',
                    'placeholder' => 'Enter title...',
                ),
                'label' => false,
                'required' => true
            ])
            ->add('Description', TextareaType::class, [
                'attr' => array(
                    'class' => 'bg-transparent block mt-10 border-b-2 w-full h-60 text-6xl outline-none',
                    'placeholder' => 'Enter Description...'
                ),
                'label' => false,
                'required' => true,
            ])
            ->add('price', NumberType::class,[
                'attr' => array(
                    'placeholder' => 'Enter price...'
                ),
                'label' => false,
                'required' => false
            ])
            ->add('image', FileType::class, array(
                'required' => false,
                'mapped' => false
            ))
            ->add('categories', EntityType::class, [
                'class' => Category::class,
                'choice_label' => 'name',
                'multiple' => true,
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Course::class,
        ]);
    }
}
