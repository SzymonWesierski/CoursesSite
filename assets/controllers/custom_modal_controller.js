import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

    async open(event) {
        const modalId = event.currentTarget.getAttribute('data-modal-id');
        const modal = document.getElementById(modalId);
    
        if (!modal) return;
    
        const fetchHtml = async (url) => {
            try {
                const response = await fetch(url, {
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });
                if (response.ok) {
                    return await response.text();
                } else {
                    console.error("Failed to load data from:", url);
                }
            } catch (error) {
                console.error("Error during fetch:", error);
            }
            return null;
        };
    
        switch (modalId) {
            case "edit-episode":
                const courseId = event.currentTarget.getAttribute('data-course-id');
                const episodeId = event.currentTarget.getAttribute('data-episode-id');

                try {
                    const response = await fetch(`/episodes/edit/${episodeId}/${courseId}`, {
                        method: 'GET',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    });
        
                    const data = await response.json();
                    modal.querySelector('.modal-body-content').innerHTML = data.episode_form;
                    modal.querySelector('input[name="episode_draft_form[course_id]"]')?.setAttribute('value', courseId);
                    modal.querySelector('input[name="episode_draft_form[episode_id]"]')?.setAttribute('value', episodeId);
                    }
                catch (error) {
                    console.error('Error submitting form:', error);
                }
                this.initEpisodeFormValidation(modal);

                break;
    
            case "create-episode":
                modal.querySelector('input[name="episode_draft_form[chapter_id]"]')?.setAttribute(
                    'value',
                    event.currentTarget.getAttribute('data-chapter-id')
                );
                this.initEpisodeFormValidation(modal);
                break;
    
            case "delete-episode":
                const delEpisodeId = event.currentTarget.getAttribute('data-episode-id');
                const delCourseId = event.currentTarget.getAttribute('data-course-id');
                document.getElementById('deleteEpisodeButton')?.setAttribute(
                    'onclick',
                    `window.location.href='/episodes/delete/${delEpisodeId}/${delCourseId}'`
                );
                break;
    
            case "edit-chapter":
                const chapterId = event.currentTarget.getAttribute('data-chapter-id');
                const chapterHtml = await fetchHtml(`/chapter/edit/${chapterId}`);
                if (chapterHtml) {
                    modal.querySelector('.modal-body-content').innerHTML = chapterHtml;
                    modal.querySelector('input[name="chapter_id"]')?.setAttribute('value', chapterId);
                }
                break;
    
            case "delete-chapter":
                const delChapterId = event.currentTarget.getAttribute('data-chapter-id');
                document.getElementById('deleteChapterButton')?.setAttribute(
                    'onclick',
                    `window.location.href='/chapter/delete/${delChapterId}'`
                );
                break;
    
            case "delete-user":
                const userId = event.currentTarget.getAttribute('data-user-id');
                document.getElementById('deleteUserButton')?.setAttribute(
                    'onclick',
                    `window.location.href='/users/delete/${userId}'`
                );
                break;
    
            case "delete-category":
                const categoryId = event.currentTarget.getAttribute('data-category-id');
                document.getElementById('deleteCategoryButton')?.setAttribute(
                    'onclick',
                    `window.location.href='/categories/delete/${categoryId}'`
                );
                break;
    
            case "edit-category":
                const editCategoryId = event.currentTarget.getAttribute('data-category-id');
                const categoryHtml = await fetchHtml(`/categories/edit/${editCategoryId}`);
                if (categoryHtml) {
                    modal.querySelector('.modal-body-content').innerHTML = categoryHtml;
                    modal.querySelector('input[name="category_id"]')?.setAttribute('value', editCategoryId);
                }
                break;
    
            case "create-category":
                modal.querySelector('input[name="parent_id"]')?.setAttribute(
                    'value',
                    event.currentTarget.getAttribute('data-parent-id')
                );
                break;

            case "approve-course":
                const approveCourseId = event.currentTarget.getAttribute('data-course-id');
                document.getElementById('approveCourseButton')?.setAttribute(
                    'onclick',
                    `window.location.href='/approve/courses/management/${approveCourseId}'`
                );
                break;

            case "ban-course":
                const banCourseId = event.currentTarget.getAttribute('data-course-id');
                document.getElementById('banCourseButton')?.setAttribute(
                    'onclick',
                    `window.location.href='/ban/courses/management/${banCourseId}'`
                );
                break;

            default:
                console.warn(`No case for modalId: ${modalId}`);
        }
    
        // Show modal
        modal.classList.add('show');
        modal.style.display = 'block';
        modal.setAttribute('aria-hidden', 'false');
        document.body.classList.add('modal-open');
    
        const backdrop = document.createElement('div');
        backdrop.className = 'modal-backdrop fade show';
        document.body.appendChild(backdrop);
    }
    
    
    hide(event) {
        const modal = event.currentTarget.closest('.modal');
        this.hideModal(modal);
    }

    hideModal(modal) {
        if (modal) {
            modal.classList.remove('show');
            modal.style.display = 'none';
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');

            const backdrop = document.querySelector('.modal-backdrop');
            if (backdrop) {
                backdrop.remove();
            }
        }
    }
    

    initEpisodeFormValidation(modal) {
        const form = modal.querySelector('form');
        if (!form) return;
    
        form.addEventListener('submit', async (event) => {
            event.preventDefault();
    
            const url = form.action;
            const formData = new FormData(form);
    
            try {
                const response = await fetch(url, {
                    method: 'POST',
                    body: formData,
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });
    
                const data = await response.json();
                
                if (data.status === 'success') {
                    this.hideModal(modal);
                    window.location.reload();

                } else if (data.status === 'error') {
                    const modalBody = modal.querySelector('.modal-body-content');

                    const chapterIdInput = form.querySelector('input[name="episode_draft_form[chapter_id]"]');
                    if (chapterIdInput) {
                        chapterIdInput.value = data.chapterId;
                    }
                    const episodeIdInput = form.querySelector('input[name="episode_draft_form[episode_id]"]');
                    if (episodeIdInput) {
                        episodeIdInput.value = data.episodeId;
                    }
                    const courseIdInput = form.querySelector('input[name="episode_draft_form[course_id]"]');
                    if (courseIdInput) {
                        courseIdInput.value = data.courseId;
                    }
                    modalBody.innerHTML = data.episode_form;

                    this.initEpisodeFormValidation(modal);
                }
            } catch (error) {
                console.error('Error submitting form:', error);
            }
        });
    }
    
}
