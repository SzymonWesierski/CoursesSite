<?php

namespace App\Models;

class CoursesManagementParams
{
    private ?string $titleParam = null;
    private ?string $sort = null;
    private int $page = 1;

    public function getTitleParam(): ?string
    {
        return $this->titleParam;
    }

    public function setTitleParam(?string $titleParam): self
    {
        $this->titleParam = $titleParam;
        return $this;
    }

    public function getSort(): ?string
    {
        return $this->sort;
    }

    public function setSort(?string $sort): self
    {
        $this->sort = $sort;
        return $this;
    }

    public function getPage(): int
    {
        return $this->page;
    }

    public function setPage(int $page): self
    {
        $this->page = $page;
        return $this;
    }
}
