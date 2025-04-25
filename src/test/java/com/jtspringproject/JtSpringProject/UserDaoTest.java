package com.jtspringproject.JtSpringProject;

import com.jtspringproject.JtSpringProject.dao.userDao;
import com.jtspringproject.JtSpringProject.models.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;

import javax.transaction.Transactional;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional
public class UserDaoTest {

    @Autowired
    private SessionFactory sessionFactory;

    @Autowired
    private userDao userDao;

    @BeforeEach
    public void cleanUp() {
        Session session = sessionFactory.getCurrentSession();
        session.createQuery("DELETE FROM User").executeUpdate();
    }

    @Test
    @Rollback(false)
    public void testSaveUser() {
        User user = new User();
        user.setUsername("johndoe_" + UUID.randomUUID());
        user.setPassword("secure123");
        user.setEmail("john@example.com");

        User savedUser = userDao.saveUser(user);

        assertThat(savedUser.getId()).isNotNull();
        assertThat(savedUser.getUsername()).startsWith("johndoe_");
    }

    @Test
    public void testGetAllUsers() {
        List<User> users = userDao.getAllUser();
        assertThat(users).isNotNull();
    }

    @Test
    @Rollback(false)
    public void testGetUser_Success() {
        String uniqueUsername = "alice_" + UUID.randomUUID();
        User user = new User();
        user.setUsername(uniqueUsername);
        user.setPassword("alice123");
        user.setEmail("alice@example.com");
        userDao.saveUser(user);

        User fetchedUser = userDao.getUser(uniqueUsername, "alice123");
        assertThat(fetchedUser).isNotNull();
        assertThat(fetchedUser.getUsername()).isEqualTo(uniqueUsername);
    }

    @Test
    public void testGetUser_InvalidCredentials() {
        User result = userDao.getUser("nonexistent_" + UUID.randomUUID(), "wrongpass");
        assertThat(result).isNull();  // Assumes you changed DAO to return null
    }

    @Test
    @Rollback(false)
    public void testUserExists() {
        String username = "bob_" + UUID.randomUUID();
        User user = new User();
        user.setUsername(username);
        user.setPassword("bobpass");
        user.setEmail("bob@example.com");
        userDao.saveUser(user);

        boolean exists = userDao.userExists(username);
        assertThat(exists).isTrue();

        boolean notExists = userDao.userExists("ghost_" + UUID.randomUUID());
        assertThat(notExists).isFalse();
    }

    @Test
    @Rollback(false)
    public void testGetUserByUsername() {
        String username = "charlie_" + UUID.randomUUID();
        User user = new User();
        user.setUsername(username);
        user.setPassword("charliepass");
        user.setEmail("charlie@example.com");
        userDao.saveUser(user);

        User foundUser = userDao.getUserByUsername(username);
        assertThat(foundUser).isNotNull();
        assertThat(foundUser.getUsername()).isEqualTo(username);
    }
}
