function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

$(document).ready(function() {
    $("#drawButton").click(function() {
        startCountdown();
    });
});

function startCountdown() {
    var remainingTime = 3; // 3 secondes"
    var messageElement = $("#message");
    messageElement.text("Le tirage commence dans " + remainingTime + " secondes...");

    var countdownInterval = setInterval(function() {
        remainingTime--;
        if (remainingTime > 0) {
            messageElement.text("Le tirage commence dans " + remainingTime + " secondes...");
        } else {
            clearInterval(countdownInterval);
            showWinner();
        }
    }, 1000);
}

function showWinner() {
    var messageElement = $("#message");
    messageElement.text("Félicitations ! Le numéro gagnant est : ");

    var winningNumber = Math.floor(Math.random() * 69) + 1;
    messageElement.append(`<span class="winningNumber">${winningNumber}</span>`);

    // Animation de feu d'artifice
    animateFireworks();
}

function animateFireworks() {
    var fireworksContainer = $("#fireworks");

    // Création de nombreux divs avec la classe "firework"
    for (var i = 0; i < 100; i++) {
        var firework = $("<div></div>").addClass("firework");
        fireworksContainer.append(firework);

        // Génération de couleurs aléatoires pour chaque feu d'artifice
        var color = getRandomColor();
        firework.css("background-color", color);
    }

    // Animation de chaque div "firework"
    $(".firework").each(function() {
        var firework = $(this);
        var x = Math.random() * 100; // Position horizontale aléatoire
        var y = Math.random() * 100; // Position verticale aléatoire
        var size = Math.random() * 20 + 5; // Taille aléatoire
        var duration = Math.random() * 4 + 1; // Durée de l'animation aléatoire (augmentée)

        // Animation de la translation et de l'opacité
        firework.css({
            "left": x + "%",
            "top": y + "%",
            "width": size + "px",
            "height": size + "px",
            "animation-duration": duration + "s" // Durée de l'animation augmentée
        });

        // Suppression de l'élément après l'animation
        firework.on("animationend", function() {
            firework.remove();
        });
    });
}
