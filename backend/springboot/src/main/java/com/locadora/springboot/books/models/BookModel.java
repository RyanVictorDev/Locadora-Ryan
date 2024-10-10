package com.locadora.springboot.books.models;

import com.locadora.springboot.publishers.models.PublisherModel;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "tb_books")
public class BookModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(length = 100, nullable = false)
    private String name;

    @Column(length = 100, nullable = false)
    private String author;

    @Column(nullable = false)
    private LocalDate launchDate;

    @Column(nullable = false)
    private int totalQuantity;

    private int totalInUse;

    @Column(nullable = false)
    private boolean isDeleted;

    @ManyToOne
    @JoinColumn(name = "publisher_id")
    private PublisherModel publisher;

    public BookModel(String name, String author, LocalDate launchDate, int totalQuantity, PublisherModel publisher) {
        this.name = name;
        this.author = author;
        this.launchDate = launchDate;
        this.totalQuantity = totalQuantity;
        this.publisher = publisher;
        this.totalInUse = 0;
        this.isDeleted = false;
    }
}
