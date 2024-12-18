<?php

namespace App\Entity;

use Symfony\Component\Validator\Constraints as Assert;
use Doctrine\ORM\Mapping as ORM;

#[ORM\MappedSuperclass]
class BaseEpisode
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    
    #[Assert\NotBlank(message: "The title is required.")]
    #[Assert\Length(
        max: 255,
        min: 2,
        maxMessage: "The title cannot exceed {{ limit }} characters.",
        minMessage: "The title must exceed {{ limit }} characters."
    )]
    #[ORM\Column(length: 255)]
    private ?string $name = '';
    
    #[Assert\Length(
        max: 1024,
        maxMessage: "The description cannot exceed {{ limit }} characters.",
    )]
    #[ORM\Column(length: 255, nullable: true)]
    private ?string $description = '';

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $videoPath = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $imagePath = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $publicImageId = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $publicVideoId = null;

    #[ORM\Column]
    private ?bool $isFreeToWatch = false;

    public function getId(): ?int
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
        return $this->description;
    }

    public function setDescription(?string $description): static
    {
        $this->description = $description;

        return $this;
    }

    public function getVideoPath(): ?string
    {
        return $this->videoPath;
    }

    public function setVideoPath(?string $videoPath): static
    {
        $this->videoPath = $videoPath;

        return $this;
    }

    public function getImagePath(): ?string
    {
        return $this->imagePath;
    }

    public function setImagePath(?string $imagePath): static
    {
        $this->imagePath = $imagePath;

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

    public function getPublicVideoId(): ?string
    {
        return $this->publicVideoId;
    }

    public function setPublicVideoId(?string $publicVideoId): static
    {
        $this->publicVideoId = $publicVideoId;

        return $this;
    }

    public function getIsFreeToWatch(): ?bool
    {
        return $this->isFreeToWatch;
    }

    public function setIsFreeToWatch(bool $isFreeToWatch): static
    {
        $this->isFreeToWatch = $isFreeToWatch;

        return $this;
    }
}
