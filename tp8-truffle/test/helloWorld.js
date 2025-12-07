const HelloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", () => {
    it("should set the name correctly", async () => {
        const helloWorld = await HelloWorld.deployed();

        // On change le nom
        await helloWorld.setName("User Name");

        // On récupère la valeur
        const result = await helloWorld.yourName();

        // Vérification
        assert(result === "User Name", "Le nom n'a pas été correctement mis à jour !");
    });
});
