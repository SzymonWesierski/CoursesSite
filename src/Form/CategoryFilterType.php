<?php

namespace App\Form;

use App\Entity\Category;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Doctrine\ORM\EntityManagerInterface;

class CategoryFilterType extends AbstractType
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('category', ChoiceType::class, [
                'choices' => $this->getCategoryChoices(),
                'placeholder' => 'Choose category',
                'required' => false,
            ]);
    }


    private function buildCategoryTree(?Category $parent = null, $level = 0)
    {
        $categories = $this->entityManager->getRepository(Category::class)->findBy(['parent' => $parent]);

        $choices = [];
        foreach ($categories as $category) {
            $choices[str_repeat('--', $level) . ' ' . $category->getName()] = $category->getId();

            $choices = array_merge($choices, $this->buildCategoryTree($category, $level + 1));
        }

        return $choices;
    }


    private function getCategoryChoices()
    {
        return $this->buildCategoryTree();
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([]);
    }
}
