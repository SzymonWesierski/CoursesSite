import './bootstrap.js';

import $ from 'jquery'; 

import { Turbo } from '@hotwired/turbo';

import 'core-js/stable';

import 'regenerator-runtime/runtime';

/*
 * Welcome to your app's main JavaScript file!
 *
 * This file will be included onto the page via the importmap() Twig function,
 * which should already be in your base.html.twig.
 */
import './styles/app.css';

import './styles/homepage.css'

import './styles/usercoursespanel.css'

import './styles/cart.css';

import './styles/security.css';

import './styles/showcourse.css';

//console.log('This log comes from assets/app.js - welcome to AssetMapper! 🎉');

// Dodanie jQuery do obiektu globalnego "window"
window.$ = $;



