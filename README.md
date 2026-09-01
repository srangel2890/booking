# Booking API

A REST API for event booking built with Ruby on Rails.

The application allows users to browse events, authenticate using JWT, create reservations, purchase different ticket types, and manage ticket availability.

## Features

- JWT-based authentication
- Event and venue management
- Multiple ticket types per event
- Reservation creation
- Automatic reservation total calculation
- Ticket inventory validation
- Unique confirmation and ticket codes
- Transactional reservation creation
- Request specs with RSpec

## Tech Stack

- Ruby
- Ruby on Rails
- MySQL
- JWT
- RSpec

## Authentication

Protected endpoints use JWT authentication.

After logging in, include the returned token in subsequent requests:

    Authorization: Bearer <token>

## Reservations

A reservation belongs to a user and an event and can contain multiple tickets.

Example request:

    POST /api/v1/reservations

    {
      "reservation": {
        "event_id": 1,
        "tickets": [
          {
            "ticket_type_id": 1,
            "attendee_name": "Jane Doe",
            "attendee_email": "jane@example.com"
          }
        ]
      }
    }

The API calculates the reservation total using the stored ticket prices and validates ticket availability before completing the reservation.

Reservation creation is performed inside a database transaction so that the reservation, tickets, and inventory updates are persisted together.

## Running the Test Suite

    bundle exec rspec

Current request specs cover event retrieval, authenticated reservation creation, inventory validation, and invalid reservation requests.
