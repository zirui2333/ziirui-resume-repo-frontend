describe('test', () => {
    it('Visit counter works properly', () => {
        cy.request('POST', '/')
        .then((response) => {
            const data = response;
            console.log(data)
        })

    })
})