import tkinter as tk  # Importation de la bibliothèque Tkinter pour créer l'interface graphique
from tkinter import messagebox  # Importation du module messagebox de Tkinter pour afficher des boîtes de message
import random  # Importation du module random pour générer des nombres aléatoires

def draw_number():
    # Fonction pour tirer un numéro et afficher le résultat dans une boîte de message
    winning_number = random.randint(1, 69)  # Générer un numéro aléatoire entre 1 et 69
    messagebox.showinfo("Résultat", f"Félicitations ! Le numéro gagnant est : {winning_number}")  # Afficher une boîte de message avec le numéro gagnant
    

# Création de la fenêtre principale
root = tk.Tk()  # Créer une instance de la classe Tk() pour la fenêtre principale
root.title("Loto FCPE")  # Définir le titre de la fenêtre principale

# Création des widgets
label = tk.Label(root, text="Cliquez pour tirer un numéro!", font=("Arial", 14))  # Créer un label avec le texte spécifié
label.pack(pady=20)  # Placer le label dans la fenêtre principale avec un espacement vertical de 20 pixels

draw_button = tk.Button(root, text="Tirer un numéro", command=draw_number)  # Créer un bouton avec le texte spécifié et la fonction à appeler lorsqu'il est cliqué
draw_button.pack()  # Placer le bouton dans la fenêtre principale

# Lancement de la boucle principale
root.mainloop()  # Lancer la boucle principale pour démarrer l'application et attendre les interactions de l'utilisateur
