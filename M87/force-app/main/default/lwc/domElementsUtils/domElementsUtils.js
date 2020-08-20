export default class DomElementsUtils {
    static removeAllChild(element) {
        while (element.firstChild) {
            element.removeChild(element.lastChild);
        }
    }

    static divReduceAppend(parentDiv, produceChildDivFunc){
        parentDiv.appendChild(produceChildDivFunc());
        return parentDiv;
    }
}