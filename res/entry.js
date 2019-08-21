'use strict';

addEventListener('load', () => {
    document.querySelector('h1.title')
            .addEventListener('click', () => {
                location.href = '/';
            });
});
