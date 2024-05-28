describe('test', () => {
    it('Visit counter works properly', () => {
        cy.request('POST', '/')
        .then((response) => {
            const data = response;
            expect(data.status).to.eq(200);
            expect(data.body).to.not.be.oneOf([null, "", undefined]);
        })
    })
})