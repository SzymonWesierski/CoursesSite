<?php

namespace App\Form;

use App\Entity\Category;
use App\Entity\Course;
use App\Entity\CourseDraft;
use App\Repository\CategoryRepository;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;

class CourseDraftFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('name', TextType::class, [
                'attr' => array(
                    'placeholder' => 'Enter title...',
                ),
                'label' => false,
                'required' => true
            ])
            ->add('Description', TextareaType::class, [
                'attr' => array(
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
                'label' => false,
                'mapped' => false
            ))
            ->add('category', EntityType::class, [
                'label' => false,
                'class' => Category::class,
                'choice_label' => 'name',
                'multiple' => false,
                'query_builder' => function (CategoryRepository $cr) {
                    return $cr->createQueryBuilder('c')
                        ->leftJoin('c.children', 'children')
                        ->where('children.id IS NULL');
                },
                'attr' => [
                    'class' => 'course-category-select',
                    'data-placeholder' => 'Choose category...',
                ],
            ])
            
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => CourseDraft::class,
        ]);
    }
}
