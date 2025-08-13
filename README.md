# Twitter Clone 🕊️  
**Réseau social dynamique construit avec Ruby on Rails 8**  
Projet personnel de développement full-stack

---

## 📍 Description

Twitter Clone est une application web inspirée de Twitter. Elle permet aux utilisateurs de publier des tweets, d’interagir avec d’autres (likes, retweets, commentaires), d’envoyer des messages privés, et de suivre leurs abonnements en temps réel.

Ce projet met l’accent sur l’interactivité, la performance et l’expérience utilisateur, en exploitant toute la puissance de Ruby on Rails 8 et Hotwire.

---

## 🚀 Fonctionnalités Implémentées

### 🔐 Authentification (via Devise)
- Inscription / Connexion / Déconnexion
- Réinitialisation du mot de passe par email
- Sessions sécurisées

### 👤 Gestion du Profil
- Création / Édition du profil (avatar, bannière, bio)
- Génération automatique d’un nom d’utilisateur (username)
- Suivi des statistiques : tweets, likes, retweets, commentaires

### 📝 Tweets & Interactions
- Création de tweets (texte uniquement)
- Timeline dynamique
- Likes / Retweets / Commentaires
- Compteur de vues
- Système de favoris (tweets enregistrés)
- Partage de tweets

### 🔔 Notifications en Temps Réel (Noticed + Turbo Streams)
- Notification en cas de like, retweet, commentaire, follow ou mention
- Gestion des notifications non lues

### 🔄 Système de Suivi
- Suivre / Se désabonner d’un utilisateur
- Listes des abonnés et abonnements
- Vérification anti-self-follow

### 💬 Messagerie Privée (DMs)
- Discussions privées entre utilisateurs

### 🔍 Recherche & Navigation
- Recherche par hashtag, utilisateurs, contenu
- Tendances (Trending Topics)
- Mode nuit

---

## 🛠️ Technologies Utilisées

| Outil / Lib | Usage |
|-------------|-------|
| **Ruby on Rails 8** | Framework principal |
| **PostgreSQL** | Base de données |
| **Devise** | Authentification |
| **Hotwire (Turbo + Stimulus.js)** | Réactivité frontend |
| **Active Storage** | Stockage des avatars & bannières |
| **Noticed** | Système de notifications |
| **Sidekiq + Redis** | Tâches en arrière-plan |
| **RSpec, FactoryBot** | Tests automatisés |

---

## 📂 Installation & Lancement

```bash
git clone https://github.com/votre-utilisateur/twitter-clone.git
cd twitter-clone
bundle install
yarn install
rails db:create db:migrate db:seed
rails s
```

Accéder à l’application : [http://localhost:3000](http://localhost:3000)

---

## 🔜 Fonctionnalités à Venir

- Vérification des comptes (badge bleu)
- Mode brouillon pour les tweets
- Système de blocage / signalement
- Statistiques avancées
- Monétisation via abonnements premium

---

## 🎯 Compétences Mises en Avant

- Maîtrise de Ruby on Rails 8 et Hotwire (Turbo Streams)
- Conception d’une architecture MVC REST complète
- Interactions en temps réel via WebSockets
- Intégration d’un système de notifications moderne
- Respect des bonnes pratiques de performance et de sécurité

---

## 👩‍💻 Auteur

*Malika (joupify)** 
Développeuse Full Stack Ruby on Rails  
[Portfolio GitHub](https://github.com/joupify)
