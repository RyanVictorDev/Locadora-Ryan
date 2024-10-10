package com.locadora.springboot.books.repositories;

import com.locadora.springboot.books.models.BookModel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<BookModel, Integer> {
    BookModel findByName(String name);
    List<BookModel> findByPublisherId(int publisherId);
    Page<BookModel> findAllByIsDeletedFalse(Pageable pageable);

    @Query("SELECT u FROM BookModel u WHERE LOWER(REPLACE(u.name, ' ', '')) LIKE LOWER(CONCAT('%', REPLACE(:name, ' ', ''), '%'))")
    Page<BookModel> findAllByName(@Param("name") String name, Pageable pageable);
}