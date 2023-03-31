# Template

An opionated starter template for web applications using Phoenix LiveView.

## Why?

I started this when I wanted to get going with a new side project (one of the many that will never be finished) and realized that `mix phx.new`, `mix phx.gen.auth` and others weren't providing everything for me to get going. In particular, there are a few features that I think every service should have - such as tracing and feature flags - that take time to set up for every new project.  
This template also comes with a few other must-haves such CI integration with GitHub Actions, a deployment blueprint for [Render](https://render.com) and more.

## Documentation

Design and service decisions are documented and explained in the `pages/` directory in this repository. These are also included in ExDoc, so you can easily view the rendered version by running `mix docs --open`.
