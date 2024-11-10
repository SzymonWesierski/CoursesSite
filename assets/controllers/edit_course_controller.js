import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['section', 'chapterList', 'chapterFormMessages'];

    connect() {
        this.currentSectionIndex = 0;
        this.showSection(this.currentSectionIndex);
    }

    navigate(event) {
        const index = parseInt(event.currentTarget.dataset.index);
        this.showSection(index);
    }

    showSection(index) {
        this.sectionTargets.forEach((section, i) => {
            section.style.display = i === index ? 'block' : 'none';
        });
    }

    submitChapterForm(event) {
        event.preventDefault();

        const formData = new FormData(this.element.querySelector('#ajax-chapter-form'));
        const createChapterUrl = "/chapter/create";
        
        fetch(createChapterUrl, {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                const chapterCount = this.chapterListTarget.children.length + 1;
                const newChapterHtml = `
                    <div class="edit-course-chapter-element">
                        <h3 class="chapter-header">
                            Chapter. ${chapterCount}
                            <span class="chapter-name">${data.chapter.name}</span>
                        </h3>
                        
                        <div class="edit-course-episode-container">
                            <p> - - No episodes yet</p>
                        </div>
                            <button class="btn-default" 
                                    type="button" 
                                    data-controller="custom-modal" 
                                    data-action="click->custom-modal#open"
                                    data-modal-id="create-episode"
                                    data-chapter-id="${data.chapter.id}">
                                <span>
                                    <img src="/icons/plus.svg" alt="plus">
                                    Add episode
                                </span>
                            </button>
                    </div>
                `;
                console.log(newChapterHtml)
                this.chapterListTarget.insertAdjacentHTML('beforeend', newChapterHtml);
                this.element.querySelector('#ajax-chapter-form').reset();
            } else {
                this.chapterFormMessagesTarget.innerHTML = '<p>An error occurred.</p>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            this.chapterFormMessagesTarget.innerHTML = '<p>An error occurred.</p>';
        });
    }
}
