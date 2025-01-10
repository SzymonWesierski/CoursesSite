<?php

namespace App\Entity;

use Symfony\Component\Validator\Constraints as Assert;
use Ramsey\Uuid\Uuid;
use App\Enum\CourseStatus;
use Doctrine\ORM\Mapping as ORM;

#[ORM\MappedSuperclass]
abstract class BaseCourse
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    private string $id;

    #[Assert\NotBlank(message: "The title is required.")]
    #[Assert\Length(
        max: 255,
        min: 2,
        maxMessage: "The title cannot exceed {{ limit }} characters.",
        minMessage: "The title must exceed {{ limit }} characters."
    )]
    #[ORM\Column(type: 'string', length: 255)]
    private ?string $name = null;

    #[Assert\NotBlank(message: "The description is required.")]
    #[Assert\Length(
        max: 1024,
        min: 20,
        maxMessage: "The description cannot exceed {{ limit }} characters.",
        minMessage: "The description must exceed {{ limit }} characters."
    )]
    #[ORM\Column(length: 1024)]
    private ?string $Description = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $ImagePath = null;

    #[ORM\Column(type: 'string', length: 64, enumType: CourseStatus::class)]
    private CourseStatus $status;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $publicImageId = null;
    
    #[Assert\PositiveOrZero(message: 'The price must be zero or a positive number.')]
    #[ORM\Column(nullable: true)]
    private ?float $price = null;

    public function __construct()
    {
        $this->id = Uuid::uuid4()->toString();
    }
    
    public function getId(): string
    {
        return $this->id;
    }

    public function setId(string $id): self
    {
        if (!Uuid::isValid($id)) {
            throw new \InvalidArgumentException('Invalid UUID format.');
        }
        $this->id = $id;

        return $this;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): static
    {
        $this->name = $name;
        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->Description;
    }

    public function setDescription(string $Description): static
    {
        $this->Description = $Description;
        return $this;
    }

    public function getImagePath(): ?string
    {
        return $this->ImagePath;
    }

    public function setImagePath(?string $ImagePath): static
    {
        $this->ImagePath = $ImagePath;
        return $this;
    }

    public function getStatus(): CourseStatus
    {
        return $this->status;
    }

    public function setStatus(CourseStatus $status): self
    {
        $this->status = $status;
        return $this;
    }

    public function getPublicImageId(): ?string
    {
        return $this->publicImageId;
    }

    public function setPublicImageId(?string $publicImageId): static
    {
        $this->publicImageId = $publicImageId;

        return $this;
    }

    public function getPrice(): ?float
    {
        return $this->price;
    }

    public function setPrice(?float $price): static
    {
        $this->price = round($price, 2);

        return $this;
    }
}
