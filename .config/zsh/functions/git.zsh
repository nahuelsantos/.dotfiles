# Git function to create a new branch from main/master
function gb() {
    if [ -z "$1" ]; then
        echo "Usage: gb <branch-name>"
        return 1
    fi
    
    # Try to get the main branch name (either main or master)
    local main_branch
    if git show-ref --verify --quiet refs/heads/main; then
        main_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        main_branch="master"
    else
        echo "Error: Neither main nor master branch found"
        return 1
    fi
    
    # Create and checkout new branch
    git checkout $main_branch
    git pull origin $main_branch
    git checkout -b $1
}

# Git function to create a new branch from develop
function gbd() {
    if [ -z "$1" ]; then
        echo "Usage: gbd <branch-name>"
        return 1
    fi
    
    # Check if develop branch exists
    if ! git show-ref --verify --quiet refs/heads/develop; then
        echo "Error: develop branch not found"
        return 1
    fi
    
    # Create and checkout new branch from develop
    git checkout develop
    git pull origin develop
    git checkout -b $1
} 