import { loadStyle } from 'lightning/platformResourceLoader';

export default class ResourcesLoader {

    static loadStyles(component, styles) {
        const stylesPromises = Array.isArray(styles) ? 
            styles.map(style => loadStyle(component, style)) : [loadStyle(component, styles)];
        Promise.all(stylesPromises).catch(err => { throw new Error(err) });
    }
}