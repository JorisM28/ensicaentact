# 📘 Documentation Flutter : Widgets Essentiels
> Guide de référence pour le projet de mise en relation Élèves / Anciens.

---

## 🏗️ 1. La Structure (Squelette de la page)

Ces widgets définissent la base de ton écran.

### **Scaffold**
C'est la structure standard d'une page (Material Design).
- **Rôle** : Fournit le toit (AppBar), le corps (body) et le sol de l'application.
- **Paramètres clés** :
  - `appBar`: La barre de titre en haut.
  - `body`: Le contenu principal de la page.
  - `floatingActionButton`: Bouton flottant (souvent en bas à droite).
  - `backgroundColor`: La couleur de fond.

### **AppBar**
La barre de navigation supérieure.
- **Paramètres clés** :
  - `title`: Un widget `Text` ("Annuaire").
  - `actions`: Liste `[]` de widgets à droite (ex: icône de paramètres).
  - `centerTitle`: `true` pour centrer le titre.

---

## 📐 2. Le Layout (Organisation de l'espace)

Comment placer les éléments les uns par rapport aux autres.

### **Column** (Vertical) ⬇️
Affiche les éléments de haut en bas.
- **Paramètres clés** :
  - `children`: `[ ]` Liste des widgets.
  - `mainAxisAlignment`: Alignement vertical (ex: `MainAxisAlignment.center`).
  - `crossAxisAlignment`: Alignement horizontal (ex: `CrossAxisAlignment.start`).

### **Row** (Horizontal) ➡️
Affiche les éléments de gauche à droite.
- **Paramètres clés** :
  - Identiques à `Column`, mais les axes sont inversés.

### **Container** 📦
Une boîte pour styliser (marges, bordures, fond).
- **Paramètres clés** :
  - `child`: Le widget à l'intérieur.
  - `padding`: Espace interne (`EdgeInsets.all(10)`).
  - `margin`: Espace externe.
  - `width` / `height`: Taille fixe.
  - `decoration`: `BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))`.

### **SizedBox**
Utilisé pour créer de l'espace vide.
- **Exemple** : `SizedBox(height: 20)` pour espacer deux textes.

---

## 🖼️ 3. Le Contenu (Ce qu'on voit)

### **Text**
Affiche du texte.
- **Utilisation** : `Text("Bonjour", style: ...)`
- **Paramètres clés** :
  - `style`: `TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)`.

### **Image**
Affiche une image.
- **Internet** : `Image.network('https://...')`
- **Local** : `Image.asset('assets/logo.png')`
- **Paramètres clés** :
  - `fit`: Comment l'image remplit l'espace (`BoxFit.cover`, `BoxFit.contain`).

### **Icon**
Affiche une icône système.
- **Utilisation** : `Icon(Icons.person)`
- **Paramètres clés** :
  - `size`: Taille en pixels.
  - `color`: Couleur de l'icône.

---

## 📜 4. Les Listes (Pour l'annuaire)

### **ListView**
Permet de faire défiler une liste d'éléments.
- **Paramètres clés** :
  - `children`: Liste des widgets à afficher.
  - `padding`: Marge autour de la liste.

### **ListTile**
Un élément de liste pré-formaté (idéal pour les contacts).
- **Paramètres clés** :
  - `leading`: Widget à gauche (Avatar).
  - `title`: Texte principal (Nom).
  - `subtitle`: Texte secondaire (Poste/Promo).
  - `trailing`: Widget à droite (Flèche >).
  - `onTap`: Fonction au clic.

---

## 👆 5. Intéractions & Boutons

### **ElevatedButton**
Bouton principal avec fond coloré.
- **Paramètres clés** :
  - `onPressed`: `() { print('Clic'); }`
  - `child`: Le texte ou l'icône du bouton.

### **TextField**
Champ de saisie texte.
- **Paramètres clés** :
  - `decoration`: `InputDecoration(labelText: "Email", border: OutlineInputBorder())`.
  - `controller`: Pour récupérer la valeur saisie.

---

## 💡 antisèche (Cheat Sheet)

| Concept | Syntaxe |
| :--- | :--- |
| **Un seul enfant** | `child: Widget()` |
| **Plusieurs enfants** | `children: [ Widget1(), Widget2() ]` |
| **Marges (Padding)** | `EdgeInsets.all(8.0)` ou `EdgeInsets.symmetric(horizontal: 10)` |
| **Fonction vide** | `() {}` |
| **Couleurs** | `Colors.blue` ou `Color(0xFF00FF00)` |

---

## 📝 Exemple Complet : Carte de Profil

```dart
Container(
  padding: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
  ),
  child: Row(
    children: [
      Icon(Icons.person, size: 40, color: Colors.blue),
      SizedBox(width: 15),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nom de l'élève", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Promotion 2024"),
        ],
      )
    ],
  ),
)