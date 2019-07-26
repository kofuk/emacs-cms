'use strict';

document.addEventListener('DOMContentLoaded', () => {
    document.querySelector('h1.title')
            .addEventListener('click', () => {
                location.href = '/';
            });
});
