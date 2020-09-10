const exists = x => x != null && x != undefined;

const Just = value => ({
    map: f => Just(f(value)),
});

const Nothing = () => ({
    map: () => Nothing(),
});

const Maybe = value => exists(value) ?
    Just(value) :
    Nothing();

const MaybeNot = value => !exists(value) ?
    Just() :
    Nothing();

export {Maybe,MaybeNot}