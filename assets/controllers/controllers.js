import { Application } from '@hotwired/stimulus';
import OwlCarouselController from './owl_carousel_controller';

const application = Application.start();
application.register('owl-carousel', OwlCarouselController);

// Opcjonalnie: rejestracja innych kontrolerów z folderu
const context = require.context('./', true, /\.js$/);
application.load(definitionsFromContext(context));



