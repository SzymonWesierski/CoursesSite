<?php

namespace App\Service;

use Cloudinary\Cloudinary;
use Cloudinary\Api\Upload\UploadApi;
use Cloudinary\Configuration\Configuration;

class CloudinaryService
{
    private $cloudinary;
    private $uploadApi;

    public function __construct()
    {
        if (empty($_ENV['CLOUDINARY_CLOUD_NAME']) || 
            empty($_ENV['CLOUDINARY_API_KEY']) || 
            empty($_ENV['CLOUDINARY_API_SECRET'])) {
            throw new \RuntimeException('Cloudinary configuration is not set in the environment variables.');
        }

        $config = Configuration::instance();
        $config->cloud->cloudName = $_ENV['CLOUDINARY_CLOUD_NAME'];
        $config->cloud->apiKey = $_ENV['CLOUDINARY_API_KEY'];
        $config->cloud->apiSecret = $_ENV['CLOUDINARY_API_SECRET'];
        $config->url->secure = true;
        
        $this->cloudinary = new Cloudinary($config);
        $this->uploadApi = new UploadApi($config);
    }

    public function uploadImage(string $imagePath, string $folderPath)
    {
        return $this->uploadApi->upload($imagePath, [
            'folder' => $folderPath
        ]);
    }

    public function uploadVideo(string $videoPath, string $folderPath)
    {
        return $this->uploadApi->upload($videoPath, [
            'resource_type' => 'video',
            'folder' => $folderPath
        ]);
    }

    public function getImageUrl(string $publicId, array $options = [])
    {
        return $this->cloudinary->image($publicId)->toUrl($options);
    }

    public function getVideoUrl(string $publicId, array $options = [])
    {
        return $this->cloudinary->video($publicId)->toUrl($options);
    }

    public function deleteImage(string $publicId)
    {
        return $this->uploadApi->destroy($publicId, ['resource_type' => 'image']);
    }

    public function deleteVideo(string $publicId)
    {
        return $this->uploadApi->destroy($publicId, ['resource_type' => 'video']);
    }
}

