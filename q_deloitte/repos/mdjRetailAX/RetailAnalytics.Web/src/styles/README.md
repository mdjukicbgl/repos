# ITCSS

https://www.xfive.co/blog/itcss-scalable-maintainable-css-architecture/

## New component? 
Make a pair of files - an object and a component. 
Structural styles in elements - checkbox.object.scss - flex, float, z-index
Theme stuff in componenet - checkbox.component.scss - colours, border style etc

## But I just need a style for the login page!?!
If you need a big button on the login page, it should become a generic modifier class on the button.
i.e. btn-large.
Rule of thumb is ugly HTML with lots of modifier classes so we can have maintainable css. If you are writing .login-page something has gone wrong. Everything needs to be modifiers on the component.

## Layers

- Settings – used with preprocessors and contain font, colors definitions, etc.
- Tools – globally used mixins and functions. It’s important not to output any CSS in the first 2 layers.
- Generic – reset and/or normalize styles, box-sizing definition, etc. This is the first layer which generates actual CSS - likely covered by bootstrap - extend with caution
- Elements – styling for bare HTML elements (like H1, A, etc.). These come with default styling from the browser so we can redefine them here - likely covered by bootstrap - extend with caution
- #### Objects – class-based selectors which define undecorated design patterns, for example media object known from OOCSS
- #### Components – specific UI components. This is where majority of our work takes place and our UI components are often composed of Objects and Components
- Trumps – utilities and helper classes with ability to override anything which goes before in the triangle, eg. hide helper class



