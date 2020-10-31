const findFirstName = field => field.dataset.fieldName === 'firstName';
const findLastName = field => field.dataset.fieldName === 'lastName';
const findUserName = field => field.dataset.fieldName === 'userName';
const findEmail = field => field.dataset.fieldName === 'email';

export {
    findFirstName,
    findLastName,
    findUserName,
    findEmail
}