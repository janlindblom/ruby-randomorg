pipeline {
  agent {
    label 'ruby'
  }

  stages {
    stage('Setup') {
      steps {
        sh 'bundle install'
      }
    }

    stage('Build') {
      steps {
        sh 'bundle exec rake build'
      }
    }

    stage('Test production branch') {
      when {
        branch 'master'
      }
      steps {
        sh 'bundle exec rake spec'
        sh 'bundle exec rake yard'
        sh 'bundle exec rake rubocop'
      }
    }

    stage('Test development branch') {
      when {
        not {
          branch 'master'
        }
      }
      steps {
        sh 'bundle exec rake spec'
      }
    }
  }
}
