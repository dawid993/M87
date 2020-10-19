const exists = x => x != null && x != undefined;

/*
* Maybe
*/
const Just = value => ({
    then: f => Just(f(value)),
});

const Nothing = () => ({
    then: () => Nothing(),
});

const Maybe = value => exists(value) ?
    Just(value) :
    Nothing();

Maybe.getNothing = () => Maybe();

/*
* Empty
*/
const ifEmpty = (value) => ({
    then: func => ifNotEmpty(func(value)),
});

const ifNotEmpty = () => ({
    then: () => ifNotEmpty(),
});

const Empty = value => !exists(value) ?
    ifEmpty(value) :
    ifNotEmpty();

Empty.getEmpty = () => Empty();

/*
* Either
*/
const Resolved = value => ({
    then: func => {
        try {
            return Resolved(func(value));
        } catch (err) {
            return Rejected(err);
        }

    },
    catch: () => Resolved(value)
});

const Rejected = error => ({
    then: () => Rejected(error),
    catch: func => {
        try {
            return Resolved(func(error));
        } catch (err) {
            return Rejected(err);
        }
    }
});

const Either = func => {
    try {
        return func(Either.getResolved, Either.getRejected);
    } catch (err) {
        return Either.getRejected(err);
    }
}

Either.getResolved = (value) => Resolved(value);
Either.getRejected = (error) => Rejected(error);

/*
* Reducers
*/

const reduceFunctions = (acc, currentFunction) => acc && currentFunction();
/*
* API exports
*/

export { Maybe, Empty, Either, reduceFunctions }