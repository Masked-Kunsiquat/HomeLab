import React from 'react'
import { graphql } from 'gatsby'

const IndexPage = ({ data }) => {
  const announcements = data.announcements.edges;

  return (
    <div>
      <h1>Home</h1>
      <h2>Announcements</h2>
      <ul>
        {announcements.map(({ node }) => (
          <li key={node.id}>
            <h2>{node.frontmatter.title}</h2>
            <p>{node.frontmatter.date}</p>
            <div dangerouslySetInnerHTML={{ __html: node.html }} />
          </li>
        ))}
      </ul>
    </div>
  )
}

export const query = graphql`
  query {
    announcements: allMarkdownRemark(filter: { fileAbsolutePath: { regex: "/(content/announcements)/" } }) {
      edges {
        node {
          id
          frontmatter {
            title
            date(formatString: "MMMM DD, YYYY")
          }
          html
        }
      }
    }
  }
`

export default IndexPage
