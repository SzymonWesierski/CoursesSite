<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\MappedSuperclass]
class BaseEpisode
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = '';

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
