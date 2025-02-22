module TweetsHelper
  def linkify_mentions(content)
    # Retourne directement le contenu s'il n'est pas une chaîne de caractères
    return content unless content.is_a?(String)

    # Extrait tous les usernames mentionnés dans le contenu (format @username)
    # `scan(/@(\w+)/)` trouve toutes les occurrences de @ suivi d'un mot (username)
    # `flatten` transforme le tableau de tableaux en un tableau simple
    # `uniq` supprime les doublons pour éviter de rechercher plusieurs fois le même utilisateur
    usernames = content.scan(/@(\w+)/).flatten.uniq

    # Initialise un hash vide pour stocker les utilisateurs trouvés
    users = {}

    # Pour chaque username mentionné, recherche l'utilisateur correspondant
    usernames.each do |username|
      # Utilise le cache pour éviter de rechercher plusieurs fois le même utilisateur
      # Si l'utilisateur est déjà dans le cache, il est récupéré directement
      # Sinon, une requête SQL est exécutée pour trouver l'utilisateur
      users[username] = Rails.cache.fetch("user_#{username}", expires_in: 5.minutes) do
        # Recherche l'utilisateur par son username
        # `&.id` utilise l'opérateur de navigation sécurisée pour éviter une erreur si l'utilisateur n'est pas trouvé
        User.find_by(username: username)&.id
      end
    end

    # Remplace chaque mention (@username) dans le contenu par un lien vers le profil de l'utilisateur
    content.gsub(/@(\w+)/) do |match|
      # Récupère le username mentionné (sans le @)
      username = $1

      # Récupère l'ID de l'utilisateur à partir du hash `users`
      user_id = users[username]

      # Si l'utilisateur est trouvé
      if user_id
        puts "✅ Utilisateur trouvé : #{username} (ID: #{user_id})" # Debug

        # Génère le chemin vers le profil de l'utilisateur
        # `rescue "#"` permet de fournir une URL par défaut en cas d'erreur
        path = Rails.application.routes.url_helpers.user_path(user_id) rescue '#'

        # Remplace la mention par un lien HTML
        "<a href='#{path}' class='mention'>#{match}</a>"
      else
        puts "⚠️ Utilisateur non trouvé : #{username}" # Debug

        # Laisse la mention telle quelle (sans la transformer en lien)
        match
      end
    end.html_safe # Rend le contenu HTML sûr pour éviter l'échappement des balises
  end
end
