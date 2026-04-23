function generateRandomEmail() {
    return 'user_' + Math.random().toString(36).substring(2, 8) + '@test.com';
}

function generateRandomId() {
    return Math.floor(Math.random() * 1000) + 1;
}
