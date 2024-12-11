<?php

namespace App\Entity;

use App\Enum\CourseStatus;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;

#[ORM\MappedSuperclass]
abstract class BaseCourse
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    private string $id;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(length: 255)]
    private ?string $Description = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $ImagePath = null;

    #[ORM\Column(type: 'string', length: 64, enumType: CourseStatus::class)]
    private CourseStatus $status;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $publicImageId = null;

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
